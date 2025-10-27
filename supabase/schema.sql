-- =========================
-- Supabase Schema (Wazeet) - Error-free
-- =========================

-- Extensions needed for UUID helpers
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 0) Types
DO $$
BEGIN
  CREATE TYPE role_type AS ENUM ('admin','user');
EXCEPTION
  WHEN duplicate_object THEN NULL;
END
$$;

-- 1) Profiles & Roles
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name  text,
  email      text UNIQUE,
  mobile     text,
  username   text UNIQUE,
  avatar_url text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.user_roles (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role       role_type NOT NULL DEFAULT 'user',
  created_at timestamptz DEFAULT now(),
  UNIQUE (user_id, role)
);

-- Fast check for admin
CREATE OR REPLACE VIEW public._is_admin AS
  SELECT ur.user_id AS id
  FROM public.user_roles ur
  WHERE ur.role = 'admin';

-- Auto-profile provisioning on auth.users insert
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, mobile)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name',''),
    COALESCE(NEW.raw_user_meta_data->>'mobile', NULL)
  )
  ON CONFLICT (id) DO NOTHING;

  RETURN NEW;
END
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE PROCEDURE public.handle_new_user();

-- 2) Catalog (services & categories)
CREATE TABLE IF NOT EXISTS public.service_categories (
  id          text PRIMARY KEY,
  name        text NOT NULL,
  description text
);

CREATE TABLE IF NOT EXISTS public.services (
  id          text PRIMARY KEY,
  name        text NOT NULL,
  category    text NOT NULL REFERENCES public.service_categories(id) ON DELETE RESTRICT,
  description text,
  price       numeric
);

-- 3) Activities (Company setup)
CREATE TABLE IF NOT EXISTS public.activities (
  id         text PRIMARY KEY,
  name       text NOT NULL,
  type       text NULL,          -- e.g., Mainland / Freezone (nullable for common)
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.sub_activities (
  id          text PRIMARY KEY,
  activity_id text NOT NULL REFERENCES public.activities(id) ON DELETE CASCADE,
  name        text NOT NULL,
  notes       text,
  created_at  timestamptz DEFAULT now()
);

-- 4) Freezone costs
CREATE TABLE IF NOT EXISTS public.freezone_costs (
  freezone_name  text NOT NULL,
  license_type   text NOT NULL,   -- Commercial / Professional / Industrial
  no_of_activity int  NOT NULL CHECK (no_of_activity BETWEEN 1 AND 10),
  cost           numeric NOT NULL,
  PRIMARY KEY (freezone_name, license_type, no_of_activity)
);

-- 5) Applications
CREATE TABLE IF NOT EXISTS public.applications (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  zone_type        text NOT NULL,        -- Mainland / Freezone
  license_type     text NOT NULL,        -- Commercial / Professional / Industrial
  activities       int  NOT NULL,
  shareholders     int  NOT NULL,
  estimated_cost   numeric,
  status           text NOT NULL DEFAULT 'draft',
  notes            text,
  activity_ids     text[] DEFAULT '{}',
  sub_activity_ids text[] DEFAULT '{}',
  created_at       timestamptz DEFAULT now()
);

-- 6) Community
CREATE TABLE IF NOT EXISTS public.posts (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  industry   text,
  content    text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.comments (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id    uuid NOT NULL REFERENCES public.posts(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content    text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- 7) Growth bookings & Payments
CREATE TABLE IF NOT EXISTS public.growth_bookings (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  service_id text,
  datetime   timestamptz NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.payments (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  amount_minor int  NOT NULL,         -- AED minor units (fils)
  currency     text NOT NULL DEFAULT 'AED',
  status       text NOT NULL,         -- e.g. 'succeeded'
  service_id   text,
  created_at   timestamptz DEFAULT now()
);

-- 8) Packages (Admin CRUD)
CREATE TABLE IF NOT EXISTS public.packages (
  id          text PRIMARY KEY,
  name        text NOT NULL,
  description text,
  price       numeric,
  category    text,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now()
);

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END
$$;

DROP TRIGGER IF EXISTS packages_updated_at ON public.packages;
CREATE TRIGGER packages_updated_at
BEFORE UPDATE ON public.packages
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- 9) Notifications & Audit
CREATE TABLE IF NOT EXISTS public.notifications (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title      text NOT NULL,
  message    text,
  is_read    boolean NOT NULL DEFAULT false,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.audit_logs (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id   uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  action     text NOT NULL,
  target     text,
  created_at timestamptz DEFAULT now()
);

-- 10) Helper RPCs
CREATE OR REPLACE FUNCTION public.count_table(tbl text)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  cnt bigint;
BEGIN
  EXECUTE format('SELECT count(*) FROM %I', tbl) INTO cnt;
  RETURN json_build_object('count', cnt);
END
$$;

CREATE OR REPLACE FUNCTION public.sum_payments_minor()
RETURNS json
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT json_build_object('sum', COALESCE(SUM(amount_minor),0))
  FROM public.payments;
$$;

-- 11) Storage buckets (idempotent, dashboard-safe)
DO $$
BEGIN
  INSERT INTO storage.buckets (id, name, public)
  VALUES ('documents','documents', false)
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO storage.buckets (id, name, public)
  VALUES ('avatars','avatars', false)
  ON CONFLICT (id) DO NOTHING;

  --INSERT INTO storage.buckets (id, name, public)
  --VALUES ('uploads','uploads', false)
  --ON CONFLICT (id) DO NOTHING;

  --INSERT INTO storage.buckets (id, name, public)
  --VALUES ('temp','temp', false)
  --ON CONFLICT (id) DO NOTHING;

  --INSERT INTO storage.buckets (id, name, public)
  --VALUES ('logs','logs', false)
  --ON CONFLICT (id) DO NOTHING;
END
$$;

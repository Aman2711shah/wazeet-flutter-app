-- =========================
-- Supabase RLS Policies
-- =========================

-- Enable RLS on all tables
ALTER TABLE public.profiles          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activities        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sub_activities    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.freezone_costs    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.applications      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.growth_bookings   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.packages          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs        ENABLE ROW LEVEL SECURITY;

-- profiles: user can see/update self
DO $$ BEGIN
  CREATE POLICY profiles_select_self ON public.profiles
  FOR SELECT USING (auth.uid() = id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY profiles_update_self ON public.profiles
  FOR UPDATE USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- catalog read for all authenticated users
DO $$ BEGIN
  CREATE POLICY service_categories_read ON public.service_categories
  FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY services_read ON public.services
  FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- activities read
DO $$ BEGIN
  CREATE POLICY activities_read ON public.activities
  FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY sub_activities_read ON public.sub_activities
  FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- freezone costs read
DO $$ BEGIN
  CREATE POLICY fz_costs_read ON public.freezone_costs
  FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- applications: owner CRUD subset + admin override
DO $$ BEGIN
  CREATE POLICY apps_select_own ON public.applications
  FOR SELECT USING (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY apps_insert_own ON public.applications
  FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY apps_update_own ON public.applications
  FOR UPDATE USING (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY apps_admin_read ON public.applications
  FOR SELECT USING (EXISTS (SELECT 1 FROM public._is_admin a WHERE a.id = auth.uid()));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY apps_admin_update ON public.applications
  FOR UPDATE USING (EXISTS (SELECT 1 FROM public._is_admin a WHERE a.id = auth.uid()));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- community: posts/comments readable by all authenticated, insert by owner
DO $$ BEGIN
  CREATE POLICY posts_read ON public.posts
  FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY posts_insert_own ON public.posts
  FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY comments_read ON public.comments
  FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY comments_insert_own ON public.comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- growth bookings & payments: owner read/insert
DO $$ BEGIN
  CREATE POLICY bookings_owner_read ON public.growth_bookings
  FOR SELECT USING (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY bookings_owner_insert ON public.growth_bookings
  FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY payments_owner_read ON public.payments
  FOR SELECT USING (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY payments_owner_insert ON public.payments
  FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- packages: read by authenticated, write by admin only
DO $$ BEGIN
  CREATE POLICY packages_read ON public.packages
  FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY packages_admin_write ON public.packages
  FOR ALL
  USING (EXISTS (SELECT 1 FROM public._is_admin a WHERE a.id = auth.uid()))
  WITH CHECK (EXISTS (SELECT 1 FROM public._is_admin a WHERE a.id = auth.uid()));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- notifications: owner read/write/insert
DO $$ BEGIN
  CREATE POLICY notifications_owner_read ON public.notifications
  FOR SELECT USING (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY notifications_owner_write ON public.notifications
  FOR UPDATE USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY notifications_owner_insert ON public.notifications
  FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- audit logs: admin read, anyone can insert
DO $$ BEGIN
  CREATE POLICY audit_read_admin ON public.audit_logs
  FOR SELECT USING (EXISTS (SELECT 1 FROM public._is_admin a WHERE a.id = auth.uid()));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY audit_insert_any ON public.audit_logs
  FOR INSERT WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- =========================
-- Storage RLS (documents & avatars buckets)
-- =========================
-- NOTE: These apply to storage.objects table.
DO $$ BEGIN
  CREATE POLICY "doc_list_own" ON storage.objects
  FOR SELECT TO authenticated
  USING (bucket_id = 'documents' AND (storage.foldername(name))[1] = auth.uid()::text);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "doc_upload_own" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'documents' AND (storage.foldername(name))[1] = auth.uid()::text);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "doc_delete_own" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'documents' AND (storage.foldername(name))[1] = auth.uid()::text);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "avatars_list_own" ON storage.objects
  FOR SELECT TO authenticated
  USING (bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "avatars_upload_own" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "avatars_delete_own" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Admin override for documents bucket (optional)
DO $$ BEGIN
  CREATE POLICY "doc_admin_all" ON storage.objects
  FOR ALL TO authenticated
  USING (
    bucket_id = 'documents'
    AND EXISTS (SELECT 1 FROM public._is_admin a WHERE a.id = auth.uid())
  )
  WITH CHECK (
    bucket_id = 'documents'
    AND EXISTS (SELECT 1 FROM public._is_admin a WHERE a.id = auth.uid())
  );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
-- End of Policies.sql
-- =========================

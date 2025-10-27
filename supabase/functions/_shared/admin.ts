import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

export function serviceClient() {
  const url = Deno.env.get("SUPABASE_URL");
  const serviceRole = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !serviceRole) throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  return createClient(url, serviceRole, { auth: { autoRefreshToken: false, persistSession: false }});
}

export async function assertAdmin(jwt?: string) {
  if (!jwt) return; // enable if calling with user JWT
  const url = Deno.env.get("SUPABASE_URL")!;
  const client = createClient(url, jwt, { global: { headers: { Authorization: `Bearer ${jwt}` } }});
  const { data: profile, error: userErr } = await client.auth.getUser();
  if (userErr || !profile.user) throw new Error("Unauthorized");
  const { data, error } = await client.from("_is_admin").select("id").eq("id", profile.user.id).maybeSingle();
  if (error || !data) throw new Error("Forbidden: admin only");
}

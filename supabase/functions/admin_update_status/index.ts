// Admin-only: update application status and optional notes.
// Caller must be an admin (checked via _is_admin view using the caller's JWT).

import { assertAdmin, serviceClient } from "../_shared/admin.ts";

Deno.serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const jwt = req.headers.get("Authorization")?.replace("Bearer ", "");
    await assertAdmin(jwt);

    const { id, status, notes } = await req.json();
    if (!id || !status) {
      return new Response("id & status required", { status: 400 });
    }

    const supa = serviceClient();
    const { error } = await supa
      .from("applications")
      .update({ status, notes })
      .eq("id", id);

    if (error) throw error;

    return new Response(JSON.stringify({ ok: true }), {
      headers: { "content-type": "application/json" },
    });
  } catch (e) {
    return new Response(
      JSON.stringify({ error: String(e) }),
      { status: 500, headers: { "content-type": "application/json" } },
    );
  }
});

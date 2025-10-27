// Minimal email notification stub.
// Replace with actual email provider integration (Resend, SendGrid, Mailgun, SES, etc.).

Deno.serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const payload = await req.json();
    // TODO: integrate a real provider here
    console.log("EMAIL NOTIFICATION PAYLOAD:", payload);

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

// Creates a Stripe Payment Intent and returns the client_secret.
// Caller: authenticated client (mobile/web) – safe because it returns client_secret only.
// Requires env: STRIPE_SECRET_KEY.

import Stripe from "https://esm.sh/stripe@16.0.0?target=deno";

Deno.serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const secret = Deno.env.get("STRIPE_SECRET_KEY");
    if (!secret) {
      return new Response("Missing STRIPE_SECRET_KEY", { status: 500 });
    }

    const { amount, currency, metadata } = await req.json();
    if (!amount || !currency) {
      return new Response("amount & currency required", { status: 400 });
    }

    const stripe = new Stripe(secret, {
      httpClient: Stripe.createFetchHttpClient(),
    });

    const pi = await stripe.paymentIntents.create({
      amount,
      currency,
      metadata,
      automatic_payment_methods: { enabled: true },
    });

    return new Response(
      JSON.stringify({ client_secret: pi.client_secret }),
      { headers: { "content-type": "application/json" } },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: String(e) }),
      { status: 500, headers: { "content-type": "application/json" } },
    );
  }
});

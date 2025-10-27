import 'package:flutter_stripe/flutter_stripe.dart';
import '../supabase_client.dart';

class StripeService {
  // Call this once at app start (e.g., in main before runApp).
  static Future<void> init(String publishableKey) async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  /// Create PI via Edge Function, then present payment sheet
  static Future<void> payAED({
    required int amountMinor,   // e.g. 15000 = AED 150.00
    required String description,
    String currency = 'aed',
    Map<String, String>? metadata,
  }) async {
    // Create PaymentIntent via Supabase Function
    final resp = await Supa.client.functions.invoke('stripe_create_payment_intent', body: {
      'amount': amountMinor,
      'currency': currency,
      'metadata': {
        'description': description,
        ...(metadata ?? {}),
      },
    });

    final data = resp.data as Map<String, dynamic>?;
    if (data == null || data['client_secret'] == null) {
      throw Exception('Failed to create payment intent (status ${resp.status}): ${resp.data}');
    }

    final clientSecret = data['client_secret'] as String;

    // Present payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Wazeet',
        allowsDelayedPaymentMethods: true,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }
}

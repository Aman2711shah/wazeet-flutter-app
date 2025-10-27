import 'package:flutter/material.dart';

/// Growth module home. In Part 4 we’ll wire booking calendar + Stripe.
class GrowthScreen extends StatelessWidget {
  const GrowthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Marketing Strategy', 'Go-to-market, content, media plans'),
      ('Accounting & Tax', 'VAT, bookkeeping, filings'),
      ('Sales Enablement', 'Funnels, scripts, CRM setup'),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, i) {
        final (title, subtitle) = items[i];
        return Card(
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.event_available),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Book: $title (booking in Part 4)')),
              );
            },
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: items.length,
    );
  }
}

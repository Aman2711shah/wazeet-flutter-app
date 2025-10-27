import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final String serviceId;
  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.watch(serviceByIdProvider(serviceId));
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Service Details'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: svc.when(
          data: (res) => res.match(
            ok: (s) => ListView(
              children: [
                Text(s.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(s.description ?? '—'),
                const SizedBox(height: 12),
                if (s.price != null)
                  Text('Price: AED ${s.price}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking & payments in Part 4')),
                    );
                  },
                  child: const Text('Book / Apply'),
                ),
              ],
            ),
            err: (e, _) => Text('Failed: $e'),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: analytics.when(
        data: (res) => res.match(
          ok: (list) => GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: list.map((m) => Card(
              child: Center(
                child: ListTile(
                  title: Text(m['metric'].toString()),
                  subtitle: Text(m['value'].toString(), style: Theme.of(context).textTheme.headlineSmall),
                ),
              ),
            )).toList(),
          ),
          err: (e, _) => Center(child: Text('Failed: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

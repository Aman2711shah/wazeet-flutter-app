import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';

class AdminAnalytics extends ConsumerWidget {
  const AdminAnalytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: analytics.when(
        data: (res) => res.match(
          ok: (list) => ListView(
            children: list.map((m) => Card(
              child: ListTile(
                title: Text(m['metric'].toString()),
                trailing: Text(m['value'].toString(), style: Theme.of(context).textTheme.titleLarge),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import 'package:go_router/go_router.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cats = ref.watch(categoriesProvider);
    final servicesAll = ref.watch(servicesProvider(null)); // all services

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          Text('Service Categories', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          cats.when(
            data: (res) => res.match(
              ok: (list) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: list.map((c) {
                  return ActionChip(
                    label: Text(c.name),
                    onPressed: () => context.go('/services/category/${c.id}'),
                  );
                }).toList(),
              ),
              err: (e, _) => Text('Failed to load categories: $e'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 16),
          Text('Popular Services', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          servicesAll.when(
            data: (res) => res.match(
              ok: (list) => Column(
                children: list.map((s) {
                  return Card(
                    child: ListTile(
                      title: Text(s.name),
                      subtitle: Text(s.description ?? '—'),
                      trailing: Text(s.price == null ? '' : 'AED ${s.price}'),
                      onTap: () => context.go('/services/item/${s.id}'),
                    ),
                  );
                }).toList(),
              ),
              err: (e, _) => Text('Failed to load services: $e'),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import 'package:go_router/go_router.dart';

class ServiceCategoryScreen extends ConsumerWidget {
  final String categoryId;
  const ServiceCategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(servicesProvider(categoryId));
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Services'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: services.when(
          data: (res) => res.match(
            ok: (list) => ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final s = list[i];
                return Card(
                  child: ListTile(
                    title: Text(s.name),
                    subtitle: Text(s.description ?? ''),
                    trailing: Text(s.price == null ? '' : 'AED ${s.price}'),
                    onTap: () => context.go('/services/item/${s.id}'),
                  ),
                );
              },
            ),
            err: (e, _) => Center(child: Text('Failed: $e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import '../../data/content_repo.dart';

class AdminContent extends ConsumerWidget {
  const AdminContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    return posts.when(
      data: (res) => res.match(
        ok: (list) => ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, i) {
            final p = list[i];
            return Card(
              child: ListTile(
                title: Text(p['content'] ?? ''),
                subtitle: Text('User: ${p['user_id']} • ${(p['created_at'] ?? '').toString().split(".").first}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final res = await contentRepo().deletePost(p['id']);
                    res.match(
                      ok: (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted'))),
                      err: (e, _) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'))),
                    );
                  },
                ),
              ),
            );
          },
        ),
        err: (e, _) => Center(child: Text('Failed: $e')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

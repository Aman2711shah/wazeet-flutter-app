import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';

class AdminUsers extends ConsumerStatefulWidget {
  const AdminUsers({super.key});

  @override
  ConsumerState<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends ConsumerState<AdminUsers> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(usersProvider(_search.text.trim().isEmpty ? null : _search.text.trim()));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _search,
            decoration: InputDecoration(
              labelText: 'Search users',
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () => setState(() {})),
            ),
            onSubmitted: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: users.when(
            data: (res) => res.match(
              ok: (list) => ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final u = list[i];
                  return Card(
                    child: ListTile(
                      title: Text(u['full_name'] ?? u['email'] ?? u['id']),
                      subtitle: Text((u['email'] ?? '') + (u['mobile'] != null ? ' • ${u['mobile']}' : '')),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          // Leave deletion to Supabase dashboard or admin function (service role) if needed.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Account deletion is restricted. Use Supabase Auth admin tools.')),
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
          ),
        ),
      ],
    );
  }
}

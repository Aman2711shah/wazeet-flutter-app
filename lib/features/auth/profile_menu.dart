import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_providers.dart';

class ProfileMenu extends ConsumerWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).value;
    final email = session?.user.email ?? '—';
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'signout') {
          await ref.read(authRepoProvider).signOut();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signed out')),
            );
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'user',
          enabled: false,
          child: Text(email),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'signout',
          child: Text('Sign out'),
        ),
      ],
      child: const CircleAvatar(child: Icon(Icons.person)),
    );
  }
}

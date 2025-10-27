import 'package:flutter/material.dart';
import '../../data/admin_repo.dart';

class AdminRoles extends StatefulWidget {
  const AdminRoles({super.key});

  @override
  State<AdminRoles> createState() => _AdminRolesState();
}

class _AdminRolesState extends State<AdminRoles> {
  final _userId = TextEditingController();
  String _role = 'user';
  bool _busy = false;

  Future<void> _assign() async {
    setState(() => _busy = true);
    final res = await adminRepo().setRole(userId: _userId.text.trim(), role: _role);
    res.match(
      ok: (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Role updated'))),
      err: (e, _) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'))),
    );
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        TextField(controller: _userId, decoration: const InputDecoration(labelText: 'User ID (auth.users.id)')),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _role,
          items: const [
            DropdownMenuItem(value: 'user', child: Text('user')),
            DropdownMenuItem(value: 'admin', child: Text('admin')),
          ],
          onChanged: (v) => setState(() => _role = v ?? 'user'),
          decoration: const InputDecoration(labelText: 'Role'),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _assign,
          child: _busy ? const CircularProgressIndicator() : const Text('Assign Role'),
        ),
        const SizedBox(height: 24),
        const Text('Tip: You can also run a direct SQL statement (below) to manage roles.'),
        const SelectableText(
          "INSERT INTO public.user_roles (user_id, role) VALUES ('<USER_ID>', 'admin') "
          "ON CONFLICT (user_id, role) DO UPDATE SET role = EXCLUDED.role;",
        ),
      ],
    );
  }
}

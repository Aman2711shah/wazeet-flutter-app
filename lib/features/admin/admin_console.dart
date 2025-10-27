import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import '../../core/supabase_client.dart';

class AdminConsole extends StatefulWidget {
  const AdminConsole({super.key});
  @override
  State<AdminConsole> createState() => _AdminConsoleState();
}

class _AdminConsoleState extends State<AdminConsole> {
  List<Map<String, dynamic>> _apps = [];
  bool _loading = true;

  final _statuses = const ['draft', 'submitted', 'approved', 'rejected'];

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await Supa.client
        .from('applications')
        .select('id,user_id,status,zone_type,license_type,created_at')
        .order('created_at', ascending: false);
    setState(() {
      _apps = List<Map<String, dynamic>>.from(rows);
      _loading = false;
    });
  }

  Future<void> _changeStatus(String id, String status) async {
    // call admin function with current user's JWT (must be admin)
    final messenger = ScaffoldMessenger.of(context);
    final jwt = Supa.client.auth.currentSession?.accessToken;
    final resp = await Supa.client.functions.invoke(
      'admin_update_status',
      body: {'id': id, 'status': status},
      headers: jwt == null ? null : {'Authorization': 'Bearer $jwt'},
    );
    if (!mounted) return;
    if (resp.data == null || resp.data['ok'] != true) {
      messenger.showSnackBar(SnackBar(content: Text('Failed: HTTP ${resp.status}')));
    } else {
      messenger.showSnackBar(const SnackBar(content: Text('Status updated')));
      _load();
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Admin Console'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _apps.isEmpty
              ? const Center(child: Text('No applications yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _apps.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final a = _apps[i];
                    return Card(
                      child: ListTile(
                        title: Text('${a['zone_type']} — ${a['license_type']}'),
                        subtitle: Text('Status: ${a['status']}  •  User: ${a['user_id']}'),
                        trailing: DropdownButton<String>(
                          value: a['status'],
                          items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                          onChanged: (v) => v == null ? null : _changeStatus(a['id'] as String, v),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/supabase_client.dart';
import '../../models/audit_log.dart';

class AdminLogs extends StatefulWidget {
  const AdminLogs({super.key});

  @override
  State<AdminLogs> createState() => _AdminLogsState();
}

class _AdminLogsState extends State<AdminLogs> {
  List<AuditLog> _items = [];
  bool _loading = true;

  Future<void> _load() async {
    final rows = await Supa.client.from('audit_logs').select('id,actor_id,action,target,created_at').order('created_at', ascending: false).limit(100);
    setState(() {
      _items = List<Map<String, dynamic>>.from(rows).map(AuditLog.fromJson).toList();
      _loading = false;
    });
  }

  @override
  void initState() { super.initState(); _load(); }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final a = _items[i];
        return Card(
          child: ListTile(
            title: Text(a.action),
            subtitle: Text('actor=${a.actorId ?? '-'} • target=${a.target ?? '-'}'),
            trailing: Text(a.createdAt.toIso8601String().split('.').first),
          ),
        );
      },
    );
  }
}

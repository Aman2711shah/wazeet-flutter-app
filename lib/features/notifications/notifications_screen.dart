import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import '../../core/supabase_client.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  Future<void> _load() async {
    final uid = Supa.client.auth.currentUser!.id;
    final rows = await Supa.client
        .from('notifications')
        .select('id,title,message,is_read,created_at')
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    setState(() {
      _items = List<Map<String, dynamic>>.from(rows);
      _loading = false;
    });
  }

  Future<void> _markRead(String id) async {
    await Supa.client.from('notifications').update({'is_read': true}).eq('id', id);
    _load();
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
            Text('Notifications'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final n = _items[i];
                return Card(
                  child: ListTile(
                    title: Text(n['title'] ?? 'Notification'),
                    subtitle: Text(n['message'] ?? ''),
                    trailing: n['is_read'] == true ? const Icon(Icons.done_all, size: 18) : null,
                    onTap: () => _markRead(n['id'] as String),
                  ),
                );
              },
            ),
    );
  }
}

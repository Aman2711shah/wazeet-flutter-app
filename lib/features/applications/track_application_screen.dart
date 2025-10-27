import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import '../../core/supabase_client.dart';

class TrackApplicationScreen extends StatefulWidget {
  const TrackApplicationScreen({super.key});

  @override
  State<TrackApplicationScreen> createState() => _TrackApplicationScreenState();
}

class _TrackApplicationScreenState extends State<TrackApplicationScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  Future<void> _load() async {
    setState(() => _loading = true);
    final uid = Supa.client.auth.currentUser!.id;
    final rows = await Supa.client
        .from('applications')
        .select('id,status,zone_type,license_type,created_at')
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    setState(() {
      _items = List<Map<String, dynamic>>.from(rows);
      _loading = false;
    });
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
            Text('Track Applications'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No applications yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final a = _items[i];
                    return Card(
                      child: ListTile(
                        title: Text('Status: ${a['status']}'),
                        subtitle: Text('${a['zone_type']} — ${a['license_type']}'),
                        trailing: Text((a['created_at'] ?? '').toString().split('.').first),
                      ),
                    );
                  },
                ),
    );
  }
}

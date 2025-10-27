import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_client.dart';
import 'document_viewer.dart';

/// Lists objects in 'documents' under {userId}/ prefix (owner-only).
class DocumentList extends StatefulWidget {
  const DocumentList({super.key});
  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  List<FileObject> _items = [];
  bool _loading = true;

  Future<void> _load() async {
    setState(() { _loading = true; });
    final userId = Supa.client.auth.currentUser!.id;
    final res = await Supa.client.storage.from('documents').list(path: userId);
    setState(() {
      _items = res;
      _loading = false;
    });
  }

  Future<void> _delete(FileObject o) async {
    final userId = Supa.client.auth.currentUser!.id;
    await Supa.client.storage.from('documents').remove(['$userId/${o.name}']);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted')));
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
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) return const Center(child: Text('No documents uploaded yet.'));

    final userId = Supa.client.auth.currentUser!.id;
    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (_, i) {
        final o = _items[i];
        return Card(
          child: ListTile(
            title: Text(o.name),
            subtitle: Text('${(o.metadata?['mimetype'] as String?) ?? ''} • ${(((o.metadata?['size'] as num?)?.toInt() ?? 0) ~/ 1024)} KB'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(o),
            ),
            onTap: () {
              final fullPath = '$userId/${o.name}';
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => DocumentViewer(path: fullPath),
              ));
            },
          ),
        );
      },
    );
  }
}

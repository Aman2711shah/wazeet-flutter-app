import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import '../../core/supabase_client.dart';

/// Basic viewer: gets a signed URL and opens with an in-app view (Image) or external browser.
/// (For production PDFs, integrate a PDF viewer plugin.)
class DocumentViewer extends StatefulWidget {
  final String path; // {userId}/{filename}
  const DocumentViewer({super.key, required this.path});

  @override
  State<DocumentViewer> createState() => _DocumentViewerState();
}

class _DocumentViewerState extends State<DocumentViewer> {
  String? _url;
  bool _loading = true;

  Future<void> _sign() async {
    setState(() => _loading = true);
    final res = await Supa.client.storage.from('documents').createSignedUrl(widget.path, 60 * 10);
    setState(() {
      _url = res;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _sign();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.path.split('/').last;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WazeetLogo(size: 24),
            const SizedBox(width: 8),
            Text(name),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _url == null
              ? const Center(child: Text('Could not sign URL.'))
              : Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      SelectableText(_url!, maxLines: 2),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () {
                          // For images you could embed Image.network(_url!)
                          // For now, let’s hint how to open externally.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copy URL to open externally.')),
                          );
                        },
                        child: const Text('Open Externally'),
                      ),
                    ],
                  ),
                ),
    );
  }
}

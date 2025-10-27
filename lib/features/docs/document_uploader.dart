import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_client.dart';

/// Uploads files to the private 'documents' bucket under path: {userId}/{filename}
class DocumentUploader extends StatefulWidget {
  const DocumentUploader({super.key});
  @override
  State<DocumentUploader> createState() => _DocumentUploaderState();
}

class _DocumentUploaderState extends State<DocumentUploader> {
  bool _uploading = false;

  Future<void> _pickAndUpload() async {
    try {
      final res = await FilePicker.platform.pickFiles(withReadStream: true);
      if (res == null || res.files.isEmpty) return;

      setState(() => _uploading = true);
      final userId = Supa.client.auth.currentUser!.id;
      final file = res.files.single;
      final path = '$userId/${file.name}';
      await Supa.client.storage.from('documents').uploadBinary(
        path,
        Uint8List.fromList(await file.readStream!.fold<List<int>>(<int>[], (a, b) => a..addAll(b))),
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true, contentType: null),
      );
      

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploaded')));
      }
    } on StorageException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: ${e.message}')));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Upload Document'),
        subtitle: const Text('PDF, images, or other files'),
        trailing: _uploading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                             : const Icon(Icons.upload_file),
        onTap: _uploading ? null : _pickAndUpload,
      ),
    );
  }
}

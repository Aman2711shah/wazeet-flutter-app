import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class Avatars {
  static Future<String?> pickAndUpload() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (img == null) return null;
    final uid = Supa.client.auth.currentUser!.id;
    final bytes = await img.readAsBytes();
    final path = '$uid/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await Supa.client.storage.from('avatars').uploadBinary(path, Uint8List.fromList(bytes), fileOptions: const FileOptions(upsert: true));
    final signed = await Supa.client.storage.from('avatars').createSignedUrl(path, 60 * 60 * 24);
    return signed;
  }
}

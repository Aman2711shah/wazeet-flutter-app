import 'package:flutter/material.dart';
import '../../core/widgets/logo.dart';
import '../../core/supabase_client.dart';
import '../../core/storage_avatars.dart';
import '../../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  bool _loading = true;

  final _fullName = TextEditingController();
  final _mobile = TextEditingController();
  final _username = TextEditingController();

  Future<void> _load() async {
    final uid = Supa.client.auth.currentUser!.id;
    final row = await Supa.client.from('profiles').select('id,full_name,email,mobile,username,avatar_url').eq('id', uid).maybeSingle();
    if (row != null) {
      setState(() {
        _profile = UserProfile.fromJson(row);
        _fullName.text = _profile?.fullName ?? '';
        _mobile.text = _profile?.mobile ?? '';
        _username.text = _profile?.username ?? '';
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final uid = Supa.client.auth.currentUser!.id;
    await Supa.client.from('profiles').upsert({
      'id': uid,
      'full_name': _fullName.text.trim(),
      'mobile': _mobile.text.trim(),
      'username': _username.text.trim().isEmpty ? null : _username.text.trim(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
      _load();
    }
  }

  Future<void> _changePhoto() async {
    final url = await Avatars.pickAndUpload();
    if (url == null) return;
    final uid = Supa.client.auth.currentUser!.id;
    await Supa.client.from('profiles').update({'avatar_url': url}).eq('id', uid);
    if (mounted) _load();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            WazeetLogo(size: 24),
            SizedBox(width: 8),
            Text('Profile'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _profile?.avatarUrl != null ? NetworkImage(_profile!.avatarUrl!) : null,
                  child: _profile?.avatarUrl == null ? const Icon(Icons.person, size: 40) : null,
                ),
                TextButton(onPressed: _changePhoto, child: const Text('Change photo')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(controller: _fullName, decoration: const InputDecoration(labelText: 'Full name')),
          const SizedBox(height: 12),
          TextField(controller: _mobile, decoration: const InputDecoration(labelText: 'Mobile')),
          const SizedBox(height: 12),
          TextField(controller: _username, decoration: const InputDecoration(labelText: 'Username (optional)')),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}

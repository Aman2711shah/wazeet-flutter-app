import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'supabase_client.dart';

/// Stream the current user's admin flag by querying the _is_admin view.
/// This auto-updates when session changes (watch sessionProvider if you prefer).
final isAdminProvider = FutureProvider<bool>((ref) async {
  final uid = Supa.client.auth.currentUser?.id;
  if (uid == null) return false;
  final rows = await Supa.client.from('_is_admin').select('id').eq('id', uid);
  return rows.isNotEmpty;
});


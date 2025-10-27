import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/supabase_client.dart';

/// Stream of Supabase AuthState -> we expose the current Session for convenience.
/// This mirrors your React AuthContext (user + session state).
final sessionProvider = StreamProvider<Session?>((ref) async* {
  // Emit current session immediately
  yield Supa.client.auth.currentSession;

  // Then listen for changes
  await for (final change in Supa.client.auth.onAuthStateChange) {
    yield change.session;
  }
});

/// Thin auth repository to keep UI clean.
class AuthRepository {
  final SupabaseClient _supabase;
  AuthRepository(this._supabase);

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
    String? mobile,
  }) {
    return _supabase.auth.signUp(
      email: email,
      password: password,
      data: fullName == null ? null : {'full_name': fullName, 'mobile': mobile},
    );
  }

  Future<void> signOut() => _supabase.auth.signOut();

  Future<void> resetPassword({required String email}) async {
    // Sends password reset email via Supabase Auth email templates
    await _supabase.auth.resetPasswordForEmail(email);
  }
}

final authRepoProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(Supa.client);
});

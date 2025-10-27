// Reads compile-time env (from --dart-define or --dart-define-from-file)
// This mirrors Vite env usage in your React app but the Flutter way.
class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  

  /// Validate at startup to fail fast if variables are missing.
  static void validate() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Missing SUPABASE_URL or SUPABASE_ANON_KEY '
        'Pass them via --dart-define or --dart-define-from-file=.env',
      );
    }
  }
}

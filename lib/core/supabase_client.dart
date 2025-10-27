import 'package:supabase_flutter/supabase_flutter.dart';
import 'env.dart';

/// Central place for Supabase initialization & access.
/// We initialize in main.dart and then use Supabase.instance.client everywhere.
class Supa {
  static Future<void> init() async {
    Env.validate();
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      // Persist session on device so the user stays signed in.
      debug: false,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

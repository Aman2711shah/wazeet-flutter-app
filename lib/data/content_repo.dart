import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/app_result.dart';

class ContentRepo {
  final SupabaseClient _db; 
  ContentRepo(this._db);

  Future<AppResult<List<Map<String,dynamic>>>> posts() async {
    try {
      final rows = await _db.from('posts').select('id,content,created_at,user_id').order('created_at', ascending:false);
      return Ok(List<Map<String,dynamic>>.from(rows));
    } catch (e,st) { 
      return Err(e,st);
    }
  }

  Future<AppResult<void>> deletePost(String id) async {
    try {
      await _db.from('posts').delete().eq('id', id);
      return const Ok(null);
    } catch (e, st) {
      return Err(e, st);
    }
  }
}
ContentRepo contentRepo()=> ContentRepo(Supa.client);

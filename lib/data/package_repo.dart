import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/package.dart';
import '../models/app_result.dart';

class PackageRepo {
  final SupabaseClient _db; PackageRepo(this._db);

  Future<AppResult<List<Package>>> list({String? search, String? category, bool? isActive}) async {
    try {
      var q = _db.from('packages').select('id,name,description,price,category,is_active');
      if (search!=null && search.trim().isNotEmpty) {
        q = q.ilike('name','%${search.trim()}%');
      }
      if (category!=null && category.trim().isNotEmpty) {
        q = q.eq('category',category);
      }
      if (isActive!=null) {
        q = q.eq('is_active',isActive);
      }
      final rows = await q;
      return Ok(List<Map<String,dynamic>>.from(rows).map(Package.fromJson).toList());
    } catch (e,st) { 
      return Err(e,st); 
    }
  }

  Future<AppResult<void>> upsert(Package p) async {
    try {
      await _db.from('packages').upsert(p.toMap());
      return const Ok(null);
    } catch (e, st) {
      return Err(e, st);
    }
  }

  Future<AppResult<void>> delete(String id) async {
    try {
      await _db.from('packages').delete().eq('id', id);
      return const Ok(null);
    } catch (e, st) {
      return Err(e, st);
    }
  }
}
PackageRepo packageRepo()=> PackageRepo(Supa.client);

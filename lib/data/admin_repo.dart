import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/app_result.dart';

class AdminRepo {
  final SupabaseClient _db; AdminRepo(this._db);

  Future<AppResult<List<Map<String,dynamic>>>> listUsers({String? search}) async {
    try {
      var q = _db.from('profiles').select('id,full_name,email,mobile,username,created_at');
      if (search!=null && search.trim().isNotEmpty) {
        q = q.ilike('full_name','%${search.trim()}%');
      }
      final rows = await q;
      return Ok(List<Map<String,dynamic>>.from(rows));
    } catch (e,st) { 
      return Err(e,st);
    }
  }

  Future<AppResult<void>> setRole({required String userId, required String role}) async {
    try {
      await _db.from('user_roles').upsert({'user_id': userId, 'role': role});
      return const Ok(null);
    } catch (e, st) {
      return Err(e, st);
   }
  }

  Future<AppResult<List<Map<String,dynamic>>>> analytics() async {
    try {
      final users = await _db.rpc('count_table', params: {'tbl':'profiles'});
      final apps = await _db.rpc('count_table', params: {'tbl':'applications'});
      final pays = await _db.rpc('sum_payments_minor');
      final bookings = await _db.rpc('count_table', params: {'tbl':'growth_bookings'});
      return Ok([
        {'metric':'Users','value': users['count']??0},
        {'metric':'Applications','value': apps['count']??0},
        {'metric':'Bookings','value': bookings['count']??0},
        {'metric':'Revenue (AED)','value': ((pays['sum']??0)/100).toStringAsFixed(2)},
      ]);
    } catch (e,st) { 
      return Err(e,st);
    }
  }
}
AdminRepo adminRepo()=> AdminRepo(Supa.client);

import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/activity.dart';
import '../models/sub_activity.dart';
import '../models/app_result.dart';

class ActivityRepo {
  final SupabaseClient _db;
  ActivityRepo(this._db);

  Future<AppResult<List<Activity>>> fetchActivities({
    String? zoneType, // "Mainland" | "Freezone" | null
    String? search,   // ilike on name
  }) async {
    try {
      var q = _db.from('activities')
        .select('id,name,type');

      if (zoneType != null && zoneType.isNotEmpty) {
        // keep items where type == zoneType or type is null (applies to both)
        q = q.or('type.eq.$zoneType,type.is.null');
      }
      if (search != null && search.trim().isNotEmpty) {
        q = q.ilike('name','%${search.trim()}%');
      }
      final rows = await q;
      final list = rows.map<Activity>((e) => Activity.fromJson(e)).toList();
      return Ok(list);
    } catch (e, st) {
      return Err(e, st);
    }
  }

  Future<AppResult<List<SubActivity>>> fetchSubActivities({
    required List<String> activityIds,
    String? search,
  }) async {
    try {
      if (activityIds.isEmpty) return const Ok(<SubActivity>[]);
      var q = _db.from('sub_activities')
        .select('id,activity_id,name,notes')
        .inFilter('activity_id', activityIds);
      if (search != null && search.trim().isNotEmpty) {
        q = q.ilike('name', '%${search.trim()}%');
      }
      final rows = await q;
      final list = rows.map<SubActivity>((e) => SubActivity.fromJson(e)).toList();
      return Ok(list);
    } catch (e, st) {
      return Err(e, st);
    }
  }
}

ActivityRepo activityRepo() => ActivityRepo(Supa.client);

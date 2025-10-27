import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/freezone_cost.dart';
import '../models/app_result.dart';

class SetupRepo {
  final SupabaseClient _db;
  SetupRepo(this._db);

  /// Get costs filtered by license type and #activities.
  /// If freezoneName provided, filters further.
  Future<AppResult<List<FreezoneCost>>> freezoneCosts({
    required String licenseType,
    required int noOfActivity,
    String? freezoneName,
  }) async {
    try {
      var q = _db.from('freezone_costs')
        .select('freezone_name,license_type,no_of_activity,cost')
        .eq('license_type', licenseType)
        .eq('no_of_activity', noOfActivity);
      if (freezoneName != null && freezoneName.trim().isNotEmpty) {
        q = q.ilike('freezone_name', '%$freezoneName%');
      }
      final rows = await q.order('freezone_name');
      return Ok(rows.map<FreezoneCost>((e) => FreezoneCost.fromJson(e)).toList());
    } catch (e, st) {
      return Err(e, st);
    }
  }

  /// Save an application draft (owner-only via RLS).
  Future<AppResult<String>> createApplicationDraft({
    required String zoneType,      // Mainland/Freezone
    required String licenseType,   // Commercial/Professional/Industrial
    required int activities,       // count
    required int shareholders,
    num? estimatedCost,
    List<String>? activityIds,     // NEW
    List<String>? subActivityIds,  // NEW
  }) async {
    try {
      final uid = Supa.client.auth.currentUser!.id;
      final row = await _db.from('applications').insert({
        'user_id': uid,
        'zone_type': zoneType,
        'license_type': licenseType,
        'activities': activities,
        'shareholders': shareholders,
        'estimated_cost': estimatedCost,
        'status': 'draft',
        'activity_ids': activityIds ?? [],
        'sub_activity_ids': subActivityIds ?? [],
      }).select('id').single();
      return Ok(row['id'] as String);
    } catch (e, st) {
      return Err(e, st);
    }
  }
}

SetupRepo setupRepo() => SetupRepo(Supa.client);

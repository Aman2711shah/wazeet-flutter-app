import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_client.dart';
import '../models/service.dart';
import '../models/service_category.dart';
import '../models/app_result.dart';

class ServiceRepo {
  final SupabaseClient _db;
  ServiceRepo(this._db);

  Future<AppResult<List<ServiceCategory>>> fetchCategories() async {
    try {
      final rows = await _db.from('service_categories').select('id,name,description').order('name');
      return Ok(rows.map<ServiceCategory>((e) => ServiceCategory.fromJson(e)).toList());
    } catch (e, st) {
      return Err(e, st);
    }
  }

  Future<AppResult<List<Service>>> fetchServices({String? categoryId}) async {
    try {
      final query = _db.from('services').select('id,name,category,description,price');
      final rows = categoryId == null
          ? await query.order('name')
          : await query.eq('category', categoryId).order('name');
      return Ok(rows.map<Service>((e) => Service.fromJson(e)).toList());
    } catch (e, st) {
      return Err(e, st);
    }
  }

  Future<AppResult<Service>> fetchServiceById(String id) async {
    try {
      final row = await _db.from('services').select('id,name,category,description,price').eq('id', id).single();
      return Ok(Service.fromJson(row));
    } catch (e, st) {
      return Err(e, st);
    }
  }
}

ServiceRepo serviceRepo() => ServiceRepo(Supa.client);

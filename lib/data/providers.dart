import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_result.dart';
import '../models/service.dart';
import '../models/service_category.dart';
import '../models/freezone_cost.dart';
import '../models/activity.dart';
import '../models/sub_activity.dart';
import 'service_repo.dart';
import 'setup_repo.dart';
import 'activity_repo.dart';
import '../core/rbac.dart';
import 'package_repo.dart';
import 'admin_repo.dart';
import 'content_repo.dart';
import '../models/package.dart';

/// isAdmin
final adminFlagProvider = isAdminProvider;

/// Packages list provider
final packagesProvider = FutureProvider.family<AppResult<List<Package>>, ({String? search, String? category, bool? isActive})>((ref, args) async {
  return packageRepo().list(search: args.search, category: args.category, isActive: args.isActive);
});

/// Analytics provider (simple list of metrics)
final analyticsProvider = FutureProvider<AppResult<List<Map<String, dynamic>>>>((ref) async {
  return adminRepo().analytics();
});

/// Users list provider
final usersProvider = FutureProvider.family<AppResult<List<Map<String, dynamic>>>, String?>((ref, search) async {
  return adminRepo().listUsers(search: search);
});

/// Posts list provider (for content mgmt)
final postsProvider = FutureProvider<AppResult<List<Map<String, dynamic>>>>((ref) async {
  return contentRepo().posts();
});

/// Categories
final categoriesProvider = FutureProvider<AppResult<List<ServiceCategory>>>((ref) async {
  return serviceRepo().fetchCategories();
});

/// Services (optionally filtered by category)
final servicesProvider = FutureProvider.family<AppResult<List<Service>>, String?>((ref, categoryId) async {
  return serviceRepo().fetchServices(categoryId: categoryId);
});

/// Single service
final serviceByIdProvider = FutureProvider.family<AppResult<Service>, String>((ref, id) async {
  return serviceRepo().fetchServiceById(id);
});

/// Freezone costs by filters
final freezoneCostsProvider = FutureProvider.family<AppResult<List<FreezoneCost>>, ({String licenseType, int activities, String? name})>((ref, args) async {
  return setupRepo().freezoneCosts(
    licenseType: args.licenseType,
    noOfActivity: args.activities,
    freezoneName: args.name,
  );
});

/// Activities list (optionally filtered by zoneType + search)
final activitiesProvider = FutureProvider.family<AppResult<List<Activity>>,({String? zoneType, String? search})>((ref, args) async {
  return activityRepo().fetchActivities(zoneType: args.zoneType, search: args.search);
});

/// Sub-activities resolved from selected activity IDs (+ optional search)
final subActivitiesProvider = FutureProvider.family<AppResult<List<SubActivity>>,({List<String> activityIds, String? search})>((ref, args) async {
  return activityRepo().fetchSubActivities(activityIds: args.activityIds, search: args.search);
});


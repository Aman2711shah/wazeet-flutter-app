class SubActivity {
  final String id;            // e.g. "bookkeeping"
  final String activityId;    // FK -> activities.id
  final String name;          // e.g. "Bookkeeping"
  final String? notes;

  SubActivity({
    required this.id,
    required this.activityId,
    required this.name,
    this.notes,
  });

  factory SubActivity.fromJson(Map<String, dynamic> j) => SubActivity(
        id: j['id'] as String,
        activityId: j['activity_id'] as String,
        name: j['name'] as String,
        notes: j['notes'] as String?,
      );
}

class Activity {
  final String id;          // e.g. "accounting_services"
  final String name;        // e.g. "Accounting Services"
  final String? type;       // "Mainland" | "Freezone" | null (applies to both)

  Activity({required this.id, required this.name, this.type});

  factory Activity.fromJson(Map<String, dynamic> j) => Activity(
        id: j['id'] as String,
        name: j['name'] as String,
        type: j['type'] as String?,
      );
}

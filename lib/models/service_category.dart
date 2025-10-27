class ServiceCategory {
  final String id;
  final String name;
  final String? description;

  ServiceCategory({required this.id, required this.name, this.description});

  factory ServiceCategory.fromJson(Map<String, dynamic> j) => ServiceCategory(
        id: j['id'] as String,
        name: j['name'] as String,
        description: j['description'] as String?,
      );
}

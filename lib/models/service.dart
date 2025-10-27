class Service {
  final String id;
  final String name;
  final String categoryId;
  final String? description;
  final num? price;

  Service({
    required this.id,
    required this.name,
    required this.categoryId,
    this.description,
    this.price,
  });

  factory Service.fromJson(Map<String, dynamic> j) => Service(
        id: j['id'] as String,
        name: j['name'] as String,
        categoryId: j['category'] as String,
        description: j['description'] as String?,
        price: j['price'] as num?,
      );
}

class Package {
  final String id;          // text id (slug)
  final String name;
  final String? description;
  final num? price;
  final String? category;   // optional grouping
  final bool isActive;

  Package({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.category,
    required this.isActive,
  });

  factory Package.fromJson(Map<String, dynamic> j) => Package(
        id: j['id'] as String,
        name: j['name'] as String,
        description: j['description'] as String?,
        price: j['price'] as num?,
        category: j['category'] as String?,
        isActive: (j['is_active'] as bool?) ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'is_active': isActive,
      };
}

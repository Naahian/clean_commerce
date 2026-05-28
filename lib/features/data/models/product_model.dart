class ProductModel {
  final String id;
  final String? ownerId;
  final String name;
  final String? description;
  final double price;
  final int quantity;
  final int? discount;
  final String? category;
  final List<String>? images;

  final Map<String, dynamic>? metadata;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    this.ownerId,
    required this.name,
    this.description,
    this.price = 0.0,
    this.quantity = 0,
    this.category,
    this.images,
    this.metadata,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    required this.discount,
  });

  int? parseToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  // Helper function to safely convert to double
  double parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// JSON → Model
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      discount: json['discount'] ?? 0,
      category: json['category'],
      images: (json['images'] != null)
          ? List<String>.from(json['images'])
          : null,
      metadata: json['metadata'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Model → JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'images': images,
      'metadata': metadata,
      'discount': discount,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Copy helper (useful for updates)
  ProductModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    double? price,
    int? quantity,
    int? discount,
    String? category,
    List<String>? images,
    Map<String, dynamic>? metadata,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      images: images ?? this.images,
      metadata: metadata ?? this.metadata,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      discount: this.discount,
    );
  }

  @override
  String toString() {
    return '''
ProductModel(
  id: $id,
  ownerId: $ownerId,
  name: $name,
  description: $description,
  price: $price,
  quantity: $quantity,
  discount: $discount,
  category: $category,
  images: $images,
  metadata: $metadata,
  isActive: $isActive,
  createdAt: $createdAt,
  updatedAt: $updatedAt
)
''';
  }
}

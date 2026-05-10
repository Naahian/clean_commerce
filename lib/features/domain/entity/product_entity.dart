import 'package:clean_commerce/features/data/models/product_model.dart';

class ProductEntity {
  final String id;
  final String ownerId;
  final String name;
  final String? description;
  final double price;
  final int quantity;
  final String? category;
  final List<String> images;
  final Map<String, dynamic>? metadata;
  final bool isActive;

  const ProductEntity({
    required this.id,
    required this.ownerId,
    required this.name,
    this.description,
    required this.price,
    required this.quantity,
    this.category,
    this.images = const [],
    this.metadata,
    this.isActive = true,
  });

  factory ProductEntity.fromProductModel(ProductModel model) {
    return ProductEntity(
      id: model.id,
      ownerId: model.ownerId ?? '',
      name: model.name,
      description: model.description,
      price: model.price,
      quantity: model.quantity,
      category: model.category,
      images: model.images ?? [],
      metadata: model.metadata,
      isActive: model.isActive,
    );
  }
}

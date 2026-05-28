// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:clean_commerce/features/data/models/product_model.dart';

class ProductEntity {
  final String id;
  final String ownerId;
  final String name;
  final String? description;
  final double price;
  final int quantity;
  final int? discount;
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
    this.discount,
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
      discount: model.discount,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'discount': discount,
      'category': category,
      'images': images,
      'metadata': metadata,
      'isActive': isActive,
    };
  }

  factory ProductEntity.fromJson(Map<String, dynamic> map) {
    return ProductEntity(
      id: map['id'] as String,
      ownerId: map['ownerId'] as String,
      name: map['name'] as String,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      price: map['price'] as double,
      quantity: map['quantity'] as int,
      discount: map['discount'] != null ? map['discount'] as int : null,
      category: map['category'] != null ? map['category'] as String : null,
      images: List.from((map['images'])),
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from((map['metadata'] as Map<String, dynamic>))
          : null,
      isActive: map['isActive'] as bool,
    );
  }
}

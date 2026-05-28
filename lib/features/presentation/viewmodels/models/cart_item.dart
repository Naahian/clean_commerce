// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:clean_commerce/features/domain/entities/product_entity.dart';

class CartItem {
  final ProductEntity product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});

  double get subtotal => product.price * quantity;

  CartItem copyWith({ProductEntity? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'product': product.toJson(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> map) {
    return CartItem(
      product: ProductEntity.fromJson(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
    );
  }
}

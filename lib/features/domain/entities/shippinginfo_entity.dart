// entities/shipping_info_entity.dart
import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/domain/entities/order_entity.dart';
import 'package:clean_commerce/features/domain/entities/product_entity.dart';

class ShippingInfoEntity {
  final String fullName;
  final String phone;
  final String email;
  final String address;

  const ShippingInfoEntity({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
  });

  OrderEntity toOrderEntity({
    required String id,
    required String userId,
    required double totalAmount,
    required String transactionId,
    required OrderStatus status,
    required PaymentStatus paymentStatus,
    required PaymentMethod paymentMethod,
    required List<ProductEntity> items,
    Map<String, dynamic>? metadata,
  }) {
    return OrderEntity(
      id: id,
      userId: userId,
      status: status,
      totalAmount: totalAmount,
      shippingAddress: address,
      paymentStatus: paymentStatus.name,
      transactionId: transactionId,
      items: items.map((p) => p.toJson()).toList(),
      metadata:
          metadata ??
          {
            'shippingInfo': {
              'fullName': fullName,
              'phone': phone,
              'email': email,
              'address': address,
            },
          },
    );
  }

  factory ShippingInfoEntity.fromJson(Map<String, dynamic> json) {
    return ShippingInfoEntity(
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  // Check if shipping info is valid
  bool get isValid {
    return fullName.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty &&
        address.isNotEmpty;
  }
}

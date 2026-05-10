import 'package:clean_commerce/features/data/models/order_model.dart';

class CreateOrderEntity {
  final String userId;
  final double totalAmount;
  final String shippingAddress;
  final String? transactionId;
  final Map<String, dynamic>? metadata;

  const CreateOrderEntity({
    required this.userId,
    required this.totalAmount,
    required this.shippingAddress,
    this.transactionId,
    this.metadata,
  });
}

class OrderEntity extends CreateOrderEntity {
  final String id;
  final String status;
  final String paymentStatus;

  const OrderEntity({
    required this.id,
    required super.userId,
    this.status = 'pending',
    required super.totalAmount,
    required super.shippingAddress,
    this.paymentStatus = 'unpaid',
    super.transactionId,
    super.metadata,
  });

  factory OrderEntity.fromOrderModel(OrderModel model) {
    return OrderEntity(
      id: model.id,
      userId: model.userId,
      status: model.status,
      totalAmount: model.totalAmount,
      shippingAddress: model.shippingAddress,
      paymentStatus: model.paymentStatus,
      transactionId: model.transactionId,
      metadata: model.metadata,
    );
  }
}

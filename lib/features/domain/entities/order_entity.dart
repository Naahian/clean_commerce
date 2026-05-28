// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/data/models/order_model.dart';

class CreateOrderEntity {
  final String userId;
  final double totalAmount;
  final String shippingAddress;
  final String? transactionId;
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic>? metadata;

  const CreateOrderEntity({
    required this.userId,
    required this.totalAmount,
    required this.shippingAddress,
    this.transactionId,
    this.metadata,
    required this.items,
  });
}

class OrderEntity extends CreateOrderEntity {
  final String id;
  final OrderStatus status;
  final String paymentStatus;
  final DateTime? createdAt;

  const OrderEntity({
    required this.id,
    required super.userId,
    this.status = OrderStatus.pending,
    required super.totalAmount,
    required super.shippingAddress,
    this.paymentStatus = 'unpaid',
    super.transactionId,
    super.metadata,
    required super.items,
    this.createdAt,
  });

  factory OrderEntity.fromOrderModel(OrderModel model) {
    OrderStatus status;
    switch (model.status) {
      case 'pending':
        status = OrderStatus.pending;
        break;
      case 'processing':
        status = OrderStatus.processing;
        break;
      case 'shipped':
        status = OrderStatus.shipped;
        break;
      case 'delivered':
        status = OrderStatus.delivered;
        break;
      case 'reqCancel':
        status = OrderStatus.reqCancel;
        break;
      case 'cancelled':
        status = OrderStatus.cancelled;
        break;

      default:
        status = OrderStatus.pending;
    }

    return OrderEntity(
      id: model.id,
      userId: model.userId,
      status: status,
      totalAmount: model.totalAmount,
      shippingAddress: model.shippingAddress,
      paymentStatus: model.paymentStatus,
      transactionId: model.transactionId,
      metadata: model.metadata,
      items: [],
      createdAt: model.createdAt,
    );
  }

  OrderEntity copyWith({
    String? id,
    OrderStatus? status,
    String? paymentStatus,
    String? userId,
    double? totalAmount,
    String? shippingAddress,
    List<Map<String, dynamic>>? items,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      items: items ?? this.items,
    );
  }
}

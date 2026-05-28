import 'package:clean_commerce/features/domain/entities/order_entity.dart';

class CreateOrderModel {
  final String userId;
  final String status;
  final double totalAmount;
  final String shippingAddress;
  final String paymentStatus;
  final String? transactionId;
  final Map<String, dynamic>? metadata;
  final List<dynamic> items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CreateOrderModel({
    required this.userId,
    this.status = 'pending',
    required this.totalAmount,
    required this.shippingAddress,
    this.paymentStatus = 'unpaid',
    this.transactionId,
    this.metadata,
    this.createdAt,
    this.updatedAt,
    required this.items,
  });

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'user_id': userId,
      'status': status,
      'total_amount': totalAmount,
      'shipping_address': shippingAddress,
      'payment_status': paymentStatus,
      'transaction_id': transactionId,
      'metadata': metadata,
      'items': items,
    };

    if (createdAt != null) {
      data['created_at'] = createdAt!.toIso8601String();
    }

    if (updatedAt != null) {
      data['updated_at'] = updatedAt!.toIso8601String();
    }

    return data;
  }

  factory CreateOrderModel.fromEntity(CreateOrderEntity entity) {
    return CreateOrderModel(
      userId: entity.userId,
      totalAmount: entity.totalAmount,
      shippingAddress: entity.shippingAddress,
      transactionId: entity.transactionId,
      metadata: entity.metadata,
      items: entity.items,
    );
  }
}

class OrderModel extends CreateOrderModel {
  final String id;
  OrderModel({
    required this.id,
    required super.userId,
    super.status = 'pending',
    required super.totalAmount,
    required super.shippingAddress,
    super.paymentStatus = 'unpaid',
    super.transactionId,
    super.metadata,
    super.createdAt,
    super.updatedAt,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'] ?? 'pending',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      shippingAddress: json['shipping_address'],
      paymentStatus: json['payment_status'] ?? 'unpaid',
      transactionId: json['transaction_id'],
      metadata: json['metadata'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      items: json['items'],
    );
  }

  /// Model → JSON
  @override
  Map<String, dynamic> toJson() {
    return {'id': id, ...super.toJson()};
  }

  /// Copy helper (useful for status/payment updates)
  OrderModel copyWith({
    String? id,
    String? userId,
    String? status,
    double? totalAmount,
    String? shippingAddress,
    String? paymentStatus,
    String? transactionId,
    Map<String, dynamic>? metadata,
    List<Map<String, dynamic>>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      transactionId: transactionId ?? this.transactionId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'OrderModel('
        'id: $id, '
        'userId: $userId, '
        'status: $status, '
        'totalAmount: $totalAmount, '
        'shippingAddress: $shippingAddress, '
        'paymentStatus: $paymentStatus, '
        'transactionId: $transactionId'
        'items: $items'
        ')';
  }
}

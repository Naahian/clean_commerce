import 'package:clean_commerce/features/domain/entities/transaction_entity.dart';

class CreateTransactionModel {
  final String userId;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final String? referenceId;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CreateTransactionModel({
    required this.userId,
    this.type = 'payment',
    required this.amount,
    this.currency = 'USD',
    this.status = 'pending',
    this.referenceId,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'status': status,
      'reference_id': referenceId,
      'metadata': metadata,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory CreateTransactionModel.fromEntity(CreateTransactionEntity entity) {
    return CreateTransactionModel(
      userId: entity.userId,
      type: entity.type,
      amount: entity.amount,
      currency: entity.currency ?? "BDT",
      referenceId: entity.referenceId,
      metadata: entity.metadata,
    );
  }
}

class TransactionModel extends CreateTransactionModel {
  final String id;
  TransactionModel({
    required this.id,
    required super.userId,
    super.type = 'payment',
    required super.amount,
    super.currency = 'USD',
    super.status = 'pending',
    super.referenceId,
    super.metadata,
    super.createdAt,
    super.updatedAt,
  });

  /// JSON → Model
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'pending',
      referenceId: json['reference_id'],
      metadata: json['metadata'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Model → JSON
  @override
  Map<String, dynamic> toJson() {
    return {'id': id, ...super.toJson()};
  }

  /// Copy helper (useful for status updates, refunds, etc.)
  TransactionModel copyWith({
    String? id,
    String? userId,
    String? type,
    double? amount,
    String? currency,
    String? status,
    String? referenceId,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      referenceId: referenceId ?? this.referenceId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TransactionModel('
        'id: $id, '
        'userId: $userId, '
        'type: $type, '
        'amount: $amount, '
        'currency: $currency, '
        'status: $status, '
        'referenceId: $referenceId'
        ')';
  }
}

import 'package:clean_commerce/features/data/models/transaction_model.dart';

// ignore: constant_identifier_names
enum Currency { USD, BDT }

class CreateTransactionEntity {
  final String userId;
  final String type;
  final double amount;
  final String? currency;
  final String? referenceId;
  final Map<String, dynamic>? metadata;

  const CreateTransactionEntity({
    required this.userId,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    this.referenceId,
    this.metadata,
  });
}

class TransactionEntity extends CreateTransactionEntity {
  final String id;
  final String status;

  const TransactionEntity({
    required this.id,
    required super.userId,
    required super.type,
    required super.amount,
    super.currency = 'USD',
    this.status = 'pending',
    super.referenceId,
    super.metadata,
  });
  factory TransactionEntity.fromTransactionModel(TransactionModel model) {
    return TransactionEntity(
      id: model.id,
      userId: model.userId,
      type: model.type,
      amount: model.amount,
      currency: model.currency,
      status: model.status,
      referenceId: model.referenceId,
      metadata: model.metadata,
    );
  }
}

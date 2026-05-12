import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/data/models/transaction_model.dart';

class CreateTransactionEntity {
  final String userId;
  final String type;
  final double amount;
  final String? currency;
  final String? referenceId;
  final DateTime? date;
  final Map<String, dynamic>? metadata;

  const CreateTransactionEntity({
    required this.userId,
    required this.type,
    required this.amount,
    this.currency = 'USD',
    this.referenceId,
    this.metadata,
    required this.date,
  });
}

class TransactionEntity extends CreateTransactionEntity {
  final String id;
  final TransactionStatus status;

  const TransactionEntity({
    required this.id,
    required super.userId,
    required super.type,
    required super.amount,
    super.currency = 'USD',
    this.status = TransactionStatus.pending,
    super.referenceId,
    super.metadata,
    required super.date,
  });
  factory TransactionEntity.fromTransactionModel(TransactionModel model) {
    TransactionStatus status;

    if (model.status == "pending") {
      status = TransactionStatus.pending;
    } else if (model.status == "completed") {
      status = TransactionStatus.completed;
    } else if (model.status == "rejected") {
      status = TransactionStatus.rejected;
    } else {
      status = TransactionStatus.pending;
    }

    return TransactionEntity(
      id: model.id,
      userId: model.userId,
      type: model.type,
      amount: model.amount,
      currency: model.currency,
      status: status,
      referenceId: model.referenceId,
      metadata: model.metadata,
      date: model.createdAt,
    );
  }
}

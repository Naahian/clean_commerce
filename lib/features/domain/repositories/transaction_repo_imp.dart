import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/features/data/models/transaction_model.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/data/services/transaction_service.dart';
import 'package:clean_commerce/features/domain/entities/result_entity.dart';
import 'package:clean_commerce/features/domain/entities/transaction_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider<AuthRepository>(
  (ref) => getIt<AuthRepository>(),
);

class TransactionRepositoryImp implements TransactionRepository {
  final TransactionService remote;
  TransactionRepositoryImp({required this.remote});

  @override
  Future<Result<TransactionEntity>> create(
    CreateTransactionEntity transaction,
  ) async {
    try {
      final result = await remote.create(
        CreateTransactionModel.fromEntity(transaction),
      );

      final entity = TransactionEntity.fromTransactionModel(result);

      return Result<TransactionEntity>(
        success: true,
        message: "Transaction created successfully.",
        data: entity,
      );
    } catch (e) {
      return Result<TransactionEntity>(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<List<TransactionEntity>>> getAll() async {
    try {
      final result = await remote.getAll();

      final transactions = result
          .map((e) => TransactionEntity.fromTransactionModel(e))
          .toList();

      return Result<List<TransactionEntity>>(
        success: true,
        message: "Transactions fetched successfully.",
        data: transactions,
      );
    } catch (e) {
      return Result<List<TransactionEntity>>(
        success: false,
        message: e.toString(),
      );
    }
  }
}

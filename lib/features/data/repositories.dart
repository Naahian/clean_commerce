import 'package:clean_commerce/features/domain/entity/comment_entity.dart';
import 'package:clean_commerce/features/domain/entity/order_entity.dart';
import 'package:clean_commerce/features/domain/entity/product_entity.dart';
import 'package:clean_commerce/features/domain/entity/profile_entity.dart';
import 'package:clean_commerce/features/domain/entity/result_entity.dart';
import 'package:clean_commerce/features/domain/entity/transaction_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<Result> login(String email, String password);
  Future<Result> googleSignIn();
  Future<Result> signUp(
    String email,
    String password,
    String displayName,
    String phone,
  );
  Future<Result> update(String? phone, String? address);
  Future<Result> logout();
  Future<Result<ProfileEntity>> getUserInfo();
  Future<Result> deleteAccount();
}

abstract class ProductRepository {
  Future<Result<List<ProductEntity>>> getAll();
  Future<Result<ProductEntity>> getSingle(String id);
}

abstract class OrderRepository {
  Future<Result<OrderEntity>> create(CreateOrderEntity order);

  Future<Result> cancel(String orderId);

  Future<Result<List<OrderEntity>>> getAll();
}

abstract class TransactionRepository {
  Future<Result<TransactionEntity>> create(CreateTransactionEntity transaction);

  Future<Result<List<TransactionEntity>>> getAll();
}

abstract class CommentRepository {
  Future<Result<CommentEntity>> create(CreateCommentEntity comment);

  Future<Result<List<CommentEntity>>> getOfProduct(String productId);

  Future<Result<void>> delete(String commentId);
}

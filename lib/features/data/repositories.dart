import 'package:clean_commerce/features/domain/entities/banner_entity.dart';
import 'package:clean_commerce/features/domain/entities/comment_entity.dart';
import 'package:clean_commerce/features/domain/entities/order_entity.dart';
import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/domain/entities/profile_entity.dart';
import 'package:clean_commerce/features/domain/entities/result_entity.dart';
import 'package:clean_commerce/features/domain/entities/transaction_entity.dart';

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
  Future<Result<List<ProductEntity>>> getAll({int limit = 8, int skip = 0});
  Future<Result<ProductEntity>> getSingle(String id);
  Future<Result<List<BannerEntity>>> getBanners();
  Future<Result<List<ProductEntity>>> getTrendingProducts();
  Future<Result<List<ProductEntity>>> getFilterByCategory(String category);
  Future<Result<List<ProductEntity>>> getFilterByPrice(bool ascending);
  Future<Result<List<ProductEntity>>> getFilterBySearch(
    String query,
  ); // Added query parameter
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

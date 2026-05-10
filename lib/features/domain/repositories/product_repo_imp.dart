import 'package:clean_commerce/core/services/localstorage_service.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/data/services/product_service.dart';
import 'package:clean_commerce/features/domain/entity/product_entity.dart';
import 'package:clean_commerce/features/domain/entity/result_entity.dart';

class ProductRepositoryImp implements ProductRepository {
  final ProductService remote;
  final LocalStorageService local;

  ProductRepositoryImp({required this.remote, required this.local});

  @override
  Future<Result<List<ProductEntity>>> getAll() async {
    try {
      final result = await remote.getAll();

      final products = result
          .map((e) => ProductEntity.fromProductModel(e))
          .toList();

      return Result<List<ProductEntity>>(
        success: true,
        message: "Products fetched successfully.",
        data: products,
      );
    } catch (e) {
      return Result<List<ProductEntity>>(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<ProductEntity>> getSingle(String id) async {
    try {
      final result = await remote.getById(id);

      final product = ProductEntity.fromProductModel(result);

      return Result<ProductEntity>(
        success: true,
        message: "Product fetched successfully.",
        data: product,
      );
    } catch (e) {
      return Result<ProductEntity>(success: false, message: e.toString());
    }
  }
}

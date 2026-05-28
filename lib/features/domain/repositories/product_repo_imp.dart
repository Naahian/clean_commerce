import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/core/services/localstorage_service.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/data/services/product_service.dart';
import 'package:clean_commerce/features/domain/entities/banner_entity.dart';
import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/domain/entities/result_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => getIt<ProductRepository>(),
);

class ProductRepositoryImp implements ProductRepository {
  final ProductService remote;
  final LocalStorageService local;

  ProductRepositoryImp({required this.remote, required this.local});

  @override
  Future<Result<List<ProductEntity>>> getAll({
    int limit = 8,
    int skip = 0,
  }) async {
    try {
      final result = await remote.getAll(limit: limit, skip: skip);

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

  @override
  Future<Result<List<BannerEntity>>> getBanners() async {
    try {
      final products = await remote.getAll(limit: 3, skip: 0);

      final banners = products.map((product) {
        // Get tags from metadata
        final tags = product.metadata?['tags'] as List<dynamic>? ?? [];

        // Determine tag based on metadata
        String tag;
        if (product.discount != null && product.discount! > 0) {
          tag = '${product.discount}% OFF';
        } else if (tags.contains('new')) {
          tag = 'NEW';
        } else if (tags.contains('featured')) {
          tag = 'FEATURED';
        } else if (tags.contains('trending')) {
          tag = 'TRENDING';
        } else {
          tag = product.category?.toUpperCase() ?? 'DISCOVER';
        }

        // Subtitle based on price and discount
        String subtitle;
        if (product.discount != null && product.discount! > 0) {
          final finalPrice = product.price * (1 - product.discount! / 100);
          subtitle = 'From ${finalPrice.toStringAsFixed(2)} TK';
        } else {
          subtitle =
              product.metadata?['shortDescription'] ??
              '${product.category} Collection';
        }

        return BannerEntity(
          id: product.id,
          title: product.name,
          subtitle: subtitle,
          tag: tag,
          image: product.images?.first,
        );
      }).toList();

      return Result(success: true, data: banners);
    } catch (e) {
      return Result(success: false);
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getTrendingProducts() async {
    try {
      final allProducts = await remote.getAll(limit: 20, skip: 0);

      final trendingProducts = allProducts
          .where((product) {
            final metadata = product.metadata ?? {};
            final tags =
                (metadata['tags'] as List<dynamic>?)?.cast<String>() ?? [];
            return tags.contains('trending') || metadata['isTrending'] == true;
          })
          .take(4)
          .toList();

      if (trendingProducts.isEmpty) {
        return Result(
          success: true,
          message: 'No trending products found',
          data: [],
        );
      }

      final entities = trendingProducts
          .map((product) => ProductEntity.fromProductModel(product))
          .toList();

      return Result(
        success: true,
        message: '${entities.length} trending products fetched',
        data: entities,
      );
    } catch (e) {
      return Result(
        success: false,
        message: 'Failed to fetch trending products: ${e.toString()}',
        data: [],
      );
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getFilterByCategory(
    String category,
  ) async {
    try {
      final result = await remote.filterByCategory(category: category);

      final products = result
          .map((e) => ProductEntity.fromProductModel(e))
          .toList();

      return Result<List<ProductEntity>>(
        success: true,
        message: "Products filtered by category successfully.",
        data: products,
      );
    } catch (e) {
      return Result<List<ProductEntity>>(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getFilterByPrice(bool ascending) async {
    try {
      final result = await remote.filterByPrice(ascending: ascending);

      final products = result
          .map((e) => ProductEntity.fromProductModel(e))
          .toList();

      return Result<List<ProductEntity>>(
        success: true,
        message: "Products filtered by price successfully.",
        data: products,
      );
    } catch (e) {
      return Result<List<ProductEntity>>(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getFilterBySearch(String query) async {
    try {
      final respnose = await remote.searchProducts(query: query);
      final data = respnose
          .map((e) => ProductEntity.fromProductModel(e))
          .toList();
      return Result<List<ProductEntity>>(success: true, data: data);
    } catch (e) {
      return Result<List<ProductEntity>>(success: false, message: e.toString());
    }
  }
}

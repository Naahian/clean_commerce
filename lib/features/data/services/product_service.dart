import 'package:clean_commerce/features/data/models/product_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// product_service.dart
class ProductService {
  final SupabaseClient _client;

  ProductService(this._client);

  // Existing method
  Future<ProductModel> getById(String id) async {
    try {
      final res = await _client.from('products').select().eq('id', id).single();
      final product = ProductModel.fromJson(res);
      return getFullImagePath(product);
    } catch (e) {
      throw Exception("Error fetching product: $e");
    }
  }

  // Get all products with pagination
  Future<List<ProductModel>> getAll({
    int limit = 8,
    int skip = 0,
    String? orderBy = 'created_at',
    bool ascending = false,
  }) async {
    try {
      final query = _client
          .from('products')
          .select()
          .order(orderBy!, ascending: ascending)
          .range(skip, skip + limit - 1);

      final res = await query;
      final products = (res as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return products.map((p) => getFullImagePath(p)).toList();
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  // Filter by category with pagination
  Future<List<ProductModel>> filterByCategory({
    required String category,
    int limit = 8,
    int skip = 0,
    String? orderBy = 'created_at',
    bool ascending = false,
  }) async {
    try {
      final query = _client
          .from('products')
          .select()
          .eq('category', category)
          .order(orderBy!, ascending: ascending)
          .range(skip, skip + limit - 1);

      final res = await query;
      final products = (res as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return products.map((p) => getFullImagePath(p)).toList();
    } catch (e) {
      throw Exception("Error fetching products by category: $e");
    }
  }

  // Filter by price with sorting (ascending or descending)
  Future<List<ProductModel>> filterByPrice({
    required bool ascending, // true = lowest first, false = highest first
    int limit = 8,
    int skip = 0,
  }) async {
    try {
      final query = _client
          .from('products')
          .select()
          .order('price', ascending: ascending)
          .range(skip, skip + limit - 1);

      final res = await query;
      final products = (res as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return products.map((p) => getFullImagePath(p)).toList();
    } catch (e) {
      throw Exception("Error fetching products by price: $e");
    }
  }

  // Search products by name/description
  Future<List<ProductModel>> searchProducts({
    required String query,
    int limit = 10,
    int skip = 0,
    String? orderBy = 'created_at',
    bool ascending = false,
  }) async {
    try {
      final res = await _client
          .from('products')
          .select()
          .ilike('name', '%$query%')
          .order(orderBy!, ascending: ascending)
          .range(skip, skip + limit - 1);

      final products = (res as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return products.map((p) => getFullImagePath(p)).toList();
    } catch (e) {
      throw Exception("Error searching products: $e");
    }
  }

  // helpers

  ProductModel getFullImagePath(ProductModel product) {
    if (product.images == null || product.images!.isEmpty) return product;

    final supabaseUrl = dotenv.get("DATABASE_URL");
    const bucketName = 'images';

    final fullUrls = product.images!.map((imagePath) {
      if (imagePath.startsWith('http')) return imagePath;
      return '$supabaseUrl/storage/v1/object/public/$bucketName/$imagePath';
    }).toList();

    return product.copyWith(images: fullUrls);
  }
}

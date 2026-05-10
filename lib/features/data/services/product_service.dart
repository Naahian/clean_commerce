import 'package:clean_commerce/features/data/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  final SupabaseClient _client;
  ProductService(this._client);

  Future<List<ProductModel>> getAll({int limit = 10, int skip = 0}) async {
    try {
      final res = await _client
          .from('products')
          .select()
          .range(skip, skip + limit - 1);

      return (res as List).map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Error fetching products");
    }
  }

  Future<ProductModel> getById(String id) async {
    try {
      final res = await _client.from('products').select().eq('id', id).single();

      return ProductModel.fromJson(res);
    } catch (e) {
      throw Exception("Error fetching product ");
    }
  }
}

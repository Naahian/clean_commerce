import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/data/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  final SupabaseClient _client;
  OrderService(this._client);

  Future<List<OrderModel>> getAll() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception("User not authenticated");

      final res = await _client.from('orders').select().eq('user_id', user.id);

      return (res as List).map((e) => OrderModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Error fetching orders: $e");
    }
  }

  Future<OrderModel> create(CreateOrderModel data) async {
    try {
      final res = await _client
          .from('orders')
          .insert(data.toJson())
          .select()
          .single();

      return OrderModel.fromJson(res);
    } catch (e, stack) {
      print(e);
      print(stack);
      throw Exception("Error creating order ");
    }
  }

  Future<OrderModel> updateStatus({
    required String id,
    required OrderStatus status,
  }) async {
    try {
      final res = await _client
          .from('orders')
          .update({'status': status.name})
          .eq('id', id)
          .select();

      return OrderModel.fromJson(res.single);
    } catch (e) {
      throw Exception("Error updating order ");
    }
  }
}

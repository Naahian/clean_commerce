import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/data/models/order_model.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/data/services/order_service.dart';
import 'package:clean_commerce/features/domain/entity/order_entity.dart';
import 'package:clean_commerce/features/domain/entity/result_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepositoryImp implements OrderRepository {
  final OrderService remote;
  OrderRepositoryImp({required this.remote});

  @override
  Future<Result<dynamic>> cancel(String orderId) async {
    try {
      await remote.updateStatus(id: orderId, status: OrderStatus.reqCancel);

      return Result(
        success: true,
        message: "Order cancellation requested successfully.",
      );
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<OrderEntity>> create(CreateOrderEntity order) async {
    try {
      final result = await remote.create(CreateOrderModel.fromEntity(order));

      final entity = OrderEntity.fromOrderModel(result);

      return Result<OrderEntity>(
        success: true,
        message: "Order created successfully.",
        data: entity,
      );
    } catch (e) {
      return Result<OrderEntity>(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<List<OrderEntity>>> getAll() async {
    try {
      final result = await remote.getAll();

      final orders = result.map((e) => OrderEntity.fromOrderModel(e)).toList();

      return Result<List<OrderEntity>>(
        success: true,
        message: "Orders fetched successfully.",
        data: orders,
      );
    } catch (e) {
      return Result<List<OrderEntity>>(success: false, message: e.toString());
    }
  }
}

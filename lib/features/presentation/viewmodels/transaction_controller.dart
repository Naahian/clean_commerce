import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/domain/entities/order_entity.dart';
import 'package:clean_commerce/features/domain/entities/transaction_entity.dart';
import 'package:clean_commerce/features/presentation/snackbar_service.dart';
import 'package:clean_commerce/features/presentation/viewmodels/cart_controller.dart';
import 'package:clean_commerce/features/presentation/viewmodels/models/cart_item.dart';
import 'package:clean_commerce/features/presentation/viewmodels/models/shipping_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderState {
  final bool isLoading;
  final List<OrderEntity> orders;
  final TransactionEntity? lastTransaction;
  final OrderEntity? currentOrder;
  final OrderEntity? selectedOrder;
  final String? errorMessage;

  const OrderState({
    this.isLoading = false,
    this.orders = const [],
    this.lastTransaction,
    this.currentOrder,
    this.selectedOrder,
    this.errorMessage,
  });

  OrderState copyWith({
    bool? isLoading,
    List<OrderEntity>? orders,
    TransactionEntity? lastTransaction,
    OrderEntity? currentOrder,
    OrderEntity? selectedOrder,
    String? errorMessage,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      lastTransaction: lastTransaction ?? this.lastTransaction,
      currentOrder: currentOrder ?? this.currentOrder,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Getters
  int get orderCount => orders.length;
  bool get hasOrders => orders.isNotEmpty;
  bool get hasError => errorMessage != null;

  // Recent orders (first 5)
  List<OrderEntity> get recentOrders => orders.take(5).toList();

  // Filtered orders
  List<OrderEntity> get pendingOrders =>
      orders.where((o) => o.status == OrderStatus.pending.name).toList();
  List<OrderEntity> get processingOrders =>
      orders.where((o) => o.status == OrderStatus.processing.name).toList();
  List<OrderEntity> get shippedOrders =>
      orders.where((o) => o.status == OrderStatus.shipped.name).toList();
  List<OrderEntity> get deliveredOrders =>
      orders.where((o) => o.status == OrderStatus.delivered.name).toList();
  List<OrderEntity> get cancelledOrders =>
      orders.where((o) => o.status == OrderStatus.cancelled.name).toList();

  // Stats
  int get totalOrders => orders.length;
  double get totalSpent =>
      orders.fold(0, (sum, order) => sum + order.totalAmount);
  int get completedOrders => deliveredOrders.length;
}

// PROVIDERS
// ===========================================================================

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return getIt<OrderRepository>();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return getIt<TransactionRepository>();
});

final orderProvider = NotifierProvider<OrderController, OrderState>(() {
  return OrderController();
});

// Derived providers
final recentOrdersProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(orderProvider).recentOrders;
});

final orderStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final state = ref.watch(orderProvider);
  return {
    'total': state.totalOrders,
    'spent': state.totalSpent,
    'completed': state.completedOrders,
  };
});

// CONTROLLER
// ===========================================================================

class OrderController extends Notifier<OrderState> {
  late final OrderRepository _orderRepository;
  late final TransactionRepository _transactionRepository;
  late final SnackbarService _snackbar;

  @override
  OrderState build() {
    _orderRepository = ref.read(orderRepositoryProvider);
    _transactionRepository = ref.read(transactionRepositoryProvider);
    _snackbar = ref.read(snackbarProvider);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });

    return const OrderState(isLoading: true);
  }

  Future<void> _loadInitialData() async {
    await Future.wait([fetchRecentOrders(), fetchLastTransaction()]);
  }

  // PUBLIC METHODS
  // --------------------------------------------------------------------------

  Future<void> fetchRecentOrders() async {
    state = state.copyWith(isLoading: true);
    print("Fetching recent orders...");

    final result = await _orderRepository.getAll();

    if (result.success && result.data != null) {
      state = state.copyWith(orders: result.data!, isLoading: false);
      print("Fetched ${result.data!.length} orders");
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.message);
      _snackbar.showError(result.message ?? "Failed to load orders");
      print("Failed to fetch orders: ${result.message}");
    }
  }

  Future<void> refreshOrders() async {
    await fetchRecentOrders();
    await fetchLastTransaction();
  }

  Future<void> fetchLastTransaction() async {
    final result = await _transactionRepository
        .getAll(); // TODO: update it after updating service,repo

    if (result.success && result.data != null) {
      state = state.copyWith(
        lastTransaction: result.data!.first,
      ); // TODO: update it after updating service,repo
    }
  }

  Future<void> getOrderById(String orderId) async {
    state = state.copyWith(isLoading: true);

    final result = await _orderRepository
        .getAll(); // TODO: update it after updating service,repo

    if (result.success && result.data != null) {
      state = state.copyWith(
        selectedOrder: result.data!.first,
        isLoading: false,
      ); // TODO: update it after updating service,repo
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.message);
      _snackbar.showError(result.message ?? "Failed to load order");
    }
  }

  Future<void> cancelOrder(String orderId) async {
    state = state.copyWith(isLoading: true);

    final result = await _orderRepository.cancel(orderId);

    if (result.success) {
      // Update the order in the list
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: OrderStatus.cancelled);
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders, isLoading: false);
      _snackbar.showSuccess("Order cancelled successfully");
    } else {
      state = state.copyWith(isLoading: false);
      _snackbar.showError(result.message ?? "Failed to cancel order");
    }
  }

  Future<void> createOrderFromCart({
    required ShippingInfo shippingInfo,
    required String paymentMethod,
    required List<CartItem> cartItems,
    required double totalAmount,
  }) async {
    state = state.copyWith(isLoading: true);
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final items = cartItems.map((item) => item.toJson()).toList();

    final result = await _orderRepository.create(
      CreateOrderEntity(
        userId: userId,
        totalAmount: totalAmount,
        shippingAddress: shippingInfo.address,
        items: items,
        metadata: shippingInfo.toJson(),
      ),
    );

    if (result.success && result.data != null) {
      final newOrder = result.data!;

      state = state.copyWith(
        orders: [newOrder, ...state.orders],
        currentOrder: newOrder,
        isLoading: false,
      );

      await ref.read(cartProvider.notifier).clearCart();
      _snackbar.showSuccess("Order placed successfully");
    } else {
      state = state.copyWith(isLoading: false);
      _snackbar.showError(result.message ?? "Failed to place order");
    }
  }

  void selectOrder(OrderEntity order) {
    state = state.copyWith(selectedOrder: order);
  }

  void clearSelectedOrder() {
    state = state.copyWith(selectedOrder: null);
  }

  void clearCurrentOrder() {
    state = state.copyWith(currentOrder: null);
  }

  List<OrderEntity> getOrdersByStatus(OrderStatus status) {
    return state.orders.where((order) => order.status == status.name).toList();
  }

  bool canCancelOrder(OrderEntity order) =>
      order.status == OrderStatus.pending.name;

  Color getOrderStatusColor(OrderStatus status) {
    return status.color;
  }
}

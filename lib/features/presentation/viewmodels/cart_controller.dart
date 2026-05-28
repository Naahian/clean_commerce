import 'package:clean_commerce/core/services/localstorage_service.dart';
import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/presentation/snackbar_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/cart_item.dart';

// STATE
// -------------------------------------------------------------

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  int get itemCount => items.length;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  double get shipping => subtotal > 100 ? 0 : 10.0;

  double get total => subtotal + shipping;
}

// PROVIDERS
// -----------------------------------------------------------------
final cartProvider = NotifierProvider<CartController, CartState>(() {
  return CartController();
});

// CONTROLLER
// -----------------------------------------------------------------
class CartController extends Notifier<CartState> {
  late final LocalStorageService _localStorage;
  late final SnackbarService _snackbar;

  @override
  CartState build() {
    _localStorage = ref.read(localStorageProvider);
    _snackbar = ref.read(snackbarProvider);

    // Delay until provider is initialized
    Future.microtask(_loadInitialState);

    return const CartState(isLoading: true);
  }
  // INITIAL LOAD

  Future<void> _loadInitialState() async {
    try {
      final loadedState = await _loadCartFromStorage();

      state = loadedState.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // PUBLIC METHODS

  Future<void> addToCart(ProductEntity product, {int quantity = 1}) async {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    List<CartItem> newItems;

    if (existingIndex != -1) {
      final existingItem = state.items[existingIndex];

      newItems = List.from(state.items);

      newItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      newItems = List.from(state.items)
        ..add(CartItem(product: product, quantity: quantity));
    }

    state = state.copyWith(items: newItems);

    await _saveCartToStorage();

    _snackbar.showSuccess('Added to cart');
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity < 1) {
      await removeFromCart(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }

      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);

    await _saveCartToStorage();
  }

  Future<void> removeFromCart(String productId) async {
    final updatedItems = state.items
        .where((item) => item.product.id != productId)
        .toList();

    state = state.copyWith(items: updatedItems);

    await _saveCartToStorage();

    _snackbar.showSuccess('Removed from cart');
  }

  Future<void> clearCart() async {
    state = const CartState();

    await _saveCartToStorage();
  }

  Future<void> refreshCart() async {
    await _loadInitialState();
  }

  bool isInCart(String productId) {
    return state.items.any((item) => item.product.id == productId);
  }

  int getQuantity(String productId) {
    final item = state.items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => throw Exception('Product not found in cart'),
    );

    return item.quantity;
  }

  // PRIVATE METHODS

  Future<CartState> _loadCartFromStorage() async {
    try {
      final jsonList = _localStorage.getCart();

      if (jsonList != null && jsonList.isNotEmpty) {
        final items = jsonList.map((json) => CartItem.fromJson(json)).toList();

        return CartState(items: items);
      }

      return const CartState();
    } catch (e, stack) {
      if (kDebugMode) {
        print(e);
        print(stack);
      }

      _snackbar.showError('Error loading cart: $e');

      return const CartState();
    }
  }

  Future<void> _saveCartToStorage() async {
    try {
      final jsonList = state.items.map((item) => item.toJson()).toList();

      await _localStorage.saveCart(jsonList);
    } catch (e) {
      _snackbar.showError('Error saving cart');
    }
  }
}

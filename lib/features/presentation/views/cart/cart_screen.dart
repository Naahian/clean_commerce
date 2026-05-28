import 'package:clean_commerce/features/presentation/viewmodels/cart_controller.dart';
import 'package:clean_commerce/features/presentation/viewmodels/models/cart_item.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/cartitem_widget.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/cart_summery_card.dart';
import 'package:clean_commerce/features/presentation/widgets/appdarawer.dart';
import 'package:clean_commerce/features/presentation/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(cartProvider);
    final ctrl = ref.read(cartProvider.notifier);
    final cartItems = state.items;

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      drawer: CustomDrawer(),
      appBar: AppBar(title: const Text('My Cart'), centerTitle: true),
      body: cartItems.isEmpty
          ? _buildEmptyCart(colorScheme, theme)
          : _buildCartItems(cartItems, ctrl, state),
    );
  }

  Column _buildCartItems(
    List<CartItem> cartItems,
    CartController ctrl,
    CartState state,
  ) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(4.w),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];

              return CartItemWidget(item: item);
            },
          ),
        ),
        CartSummeryCard(subtotal: state.subtotal, shipping: 60),
      ],
    );
  }

  Center _buildEmptyCart(ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withAlpha(50),
          ),
          SizedBox(height: 2.h),
          Text(
            'Your cart is empty',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withAlpha(50),
            ),
          ),
          Text(
            'Do Some Shopping  : )',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.secondary.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:clean_commerce/features/presentation/views/cart/widgets/cart_item.dart';
import 'package:clean_commerce/features/presentation/views/cart/widgets/cart_summery_card.dart';
import 'package:clean_commerce/features/presentation/widgets/appdarawer.dart';
import 'package:clean_commerce/features/presentation/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Wireless Headphones',
      'price': 79.99,
      'quantity': 1,
      'image': 'https://picsum.photos/id/20/200/200',
    },
    {
      'id': '2',
      'name': 'Smart Watch',
      'price': 199.99,
      'quantity': 1,
      'image': 'https://picsum.photos/id/21/200/200',
    },
    {
      'id': '3',
      'name': 'Phone Case',
      'price': 19.99,
      'quantity': 2,
      'image': 'https://picsum.photos/id/22/200/200',
    },
  ];

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _cartItems[index]['quantity'] = newQuantity;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  double get _subtotal {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      drawer: CustomDrawer(),
      appBar: AppBar(title: const Text('My Cart'), centerTitle: true),
      body: _cartItems.isEmpty
          ? _buildEmptyCart(colorScheme, theme)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return CartItem(
                        item: item,
                        onQuantityChanged: (qty) => _updateQuantity(index, qty),
                        onRemove: () => _removeItem(index),
                      );
                    },
                  ),
                ),
                CartSummeryCard(subtotal: _subtotal, shipping: 60),
              ],
            ),
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

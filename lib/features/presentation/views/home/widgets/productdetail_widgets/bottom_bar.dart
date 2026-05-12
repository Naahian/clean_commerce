import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'quantity_counter.dart';

class ProductBottomBar extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final int quantity;
  final Function(int) onQuantityChanged;

  const ProductBottomBar({
    required this.theme,
    required this.colorScheme,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity Selector in Bottom Bar
          QuantityCounter(
            quantity: quantity,
            colorScheme: colorScheme,
            onQuantityChanged: onQuantityChanged,
          ),
          SizedBox(width: 8),
          // Add to Cart Button
          Expanded(
            flex: 2,
            child: _AddToCartButton(
              theme: theme,
              colorScheme: colorScheme,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Add to Cart Button Component
// ============================================================================

class _AddToCartButton extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onPressed;

  const _AddToCartButton({
    required this.theme,
    required this.colorScheme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Add to Cart',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

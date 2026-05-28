import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/viewmodels/settings_notifier.dart';
import 'package:clean_commerce/features/presentation/views/cart/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CartSummeryCard extends ConsumerWidget {
  final double subtotal;
  final double shipping;
  double get _total => subtotal + shipping;

  const CartSummeryCard({
    super.key,
    required this.subtotal,
    required this.shipping,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currency = ref.read(settingsProvider.notifier).getCurrencyChar();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withAlpha(15),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.sp),
          topRight: Radius.circular(24.sp),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(005),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            theme,
            'Subtotal',
            '$currency ${subtotal.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            theme,
            'Shipping',
            shipping == 0 ? 'Free' : '$currency ${shipping.toStringAsFixed(2)}',
          ),
          Divider(height: 2.h, color: colorScheme.outline.withAlpha(10)),
          _buildSummaryRow(
            theme,
            'Total',
            '$currency ${_total.toStringAsFixed(2)}',
            isTotal: true,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CheckoutScreen(subtotal: subtotal),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    ThemeData theme,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium
                : theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

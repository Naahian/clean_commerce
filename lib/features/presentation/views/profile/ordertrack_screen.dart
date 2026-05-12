import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/order_track_line.dart';
import 'package:clean_commerce/features/presentation/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Order Track")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            OrderTrackline(status: OrderStatus.processing),
            SizedBox(height: 6.h),

            // Order Info
            _orderInfoCard(colorScheme, theme),
            SizedBox(height: 2.h),

            // Shipping Address
            _shippingAddressCard(colorScheme, theme),
            SizedBox(height: 2.h),

            // Order Items
            _orderItemsCard(colorScheme, theme),
          ],
        ),
      ),
    );
  }

  Container _orderItemsCard(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Items', style: theme.textTheme.titleSmall),
          SizedBox(height: 1.h),
          _buildItemRow(theme, 'Wireless Headphones', 1, 79.99),
          _buildItemRow(theme, 'Smart Watch', 2, 59.99),
          _buildItemRow(theme, 'Phone Case', 1, 19.99),
        ],
      ),
    );
  }

  Container _shippingAddressCard(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Shipping Address', style: theme.textTheme.titleSmall),
          SizedBox(height: 1.h),
          Text(
            'John Doe, 123 Main St, New York, NY 10001',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Container _orderInfoCard(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryFixedDim.withAlpha(50),
            colorScheme.tertiaryFixedDim.withAlpha(50),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withAlpha(30)),
      ),
      child: Column(
        children: [
          _buildRow('Order ID', '#ORD-2024-001', theme),
          _buildRow('Total Amount', '\$245.50', theme, isAmount: true),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payment Status", style: theme.textTheme.bodyMedium),
                StatusChip(label: "completed", color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    ThemeData theme, {
    bool isAmount = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: isAmount
                ? theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(
    ThemeData theme,
    String name,
    int quantity,
    double price,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(child: Text(name, style: theme.textTheme.bodyMedium)),
          Text('x$quantity', style: theme.textTheme.bodySmall),
          SizedBox(width: 12.w),
          Text(
            '\$${(price * quantity).toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

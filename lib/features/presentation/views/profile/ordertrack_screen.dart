import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/domain/entities/order_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/settings_notifier.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/order_track_line.dart';
import 'package:clean_commerce/features/presentation/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderEntity order;

  const OrderTrackingScreen({super.key, required this.order});

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
            OrderTrackline(status: order.status),
            SizedBox(height: 6.h),
            _orderInfoCard(colorScheme, theme),
            SizedBox(height: 2.h),
            _shippingAddressCard(colorScheme, theme),
            //TODO: Add items list
          ],
        ),
      ),
    );
  }

  Container _shippingAddressCard(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      width: double.infinity,
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
          Text(order.shippingAddress, style: theme.textTheme.bodyMedium),
          //TODO: FIX item list display
          // Text(order.items.toString(), style: theme.textTheme.bodyMedium),
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
            colorScheme.tertiaryFixedDim.withAlpha(50),
            colorScheme.primaryFixedDim.withAlpha(50),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Order ID', order.id, theme),
          Consumer(
            builder: (_, ref, _) {
              String currency = ref.read(currencyProvider);

              return _buildRow(
                'Total Amount',
                '$currency ${order.totalAmount.toStringAsFixed(2)}',
                theme,
                isAmount: true,
              );
            },
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payment Status", style: theme.textTheme.bodyMedium),
                StatusChip(
                  label: order.paymentStatus,
                  color: order.paymentStatus == PaymentStatus.paid.name
                      ? Colors.green
                      : Colors.red,
                ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          SizedBox(width: 5),
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
          Consumer(
            builder: (_, ref, _) {
              String currency = ref.read(currencyProvider);
              return Text(
                '$currency${(price * quantity).toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

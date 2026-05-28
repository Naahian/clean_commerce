import 'package:clean_commerce/features/domain/entities/order_entity.dart';
import 'package:clean_commerce/features/domain/entities/transaction_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/settings_notifier.dart';
import 'package:clean_commerce/features/presentation/views/profile/ordertrack_screen.dart';
import 'package:clean_commerce/features/presentation/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TileInfoItem extends StatelessWidget {
  final OrderEntity? order;
  final TransactionEntity? transaction;
  bool get isOrder => order != null;

  const TileInfoItem({super.key, this.order, this.transaction});

  Color _getColor(String status) {
    switch (status) {
      case 'pending' || 'processing' || 'shipped':
        return Colors.blue;
      case 'completed' || 'delivered':
        return Colors.green;
      case 'rejected' || 'cancelled':
        return Colors.red;
      case 'reqCancel':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending' || 'processing' || 'shipped':
        return Icons.pending_outlined;
      case 'completed' || 'delivered':
        return Icons.check_circle_outline;
      case 'rejected' || 'cancelled' || 'reqCancel':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (transaction == null && order == null) {
      throw ArgumentError("Either order or transaction must be provided");
    }
    var formattedDate = "";
    var status;
    var statusColor;
    var statusIcon;
    var id;
    var amount;

    if (order != null) {
      print("Building TileInfoItem  for order: $order");
      formattedDate = DateFormat.yMMMd().format(order!.createdAt!);
      status = order!.status.name;
      statusColor = _getColor(order!.status.name);
      statusIcon = _getIcon(order!.status.name);
      id = order!.id;
      amount = order!.totalAmount;
    } else if (transaction != null) {
      print("Building TileInfoItem for transaction: ${transaction!.id}");
      formattedDate = DateFormat.yMMMd().format(transaction!.date!);
      status = transaction!.status.name;
      statusColor = _getColor(transaction!.status.name);
      statusIcon = _getIcon(transaction!.status.name);
      id = transaction!.id;
      amount = transaction!.amount;
    }

    return ListTile(
      leading: StatusIcon(
        icon: statusIcon,
        color: statusColor,
        size: 20,
        padding: 8,
      ),
      title: Text(
        id,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formattedDate, style: theme.textTheme.bodySmall),
          SizedBox(height: 0.5.h),
          StatusChip(label: status, color: statusColor, compact: true),
        ],
      ),
      trailing: _buildTrailing(context, theme, colorScheme, amount),
    );
  }

  Column _buildTrailing(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    double amount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer(
          builder: (_, ref, _) {
            String currency = ref.read(currencyProvider);

            return Text(
              '$currency${amount.toStringAsFixed(2)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            );
          },
        ),
        SizedBox(height: 0.5.h),
        if (transaction == null)
          TextButton(
            onPressed: isOrder
                ? () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(order: order!),
                    ),
                  )
                : null,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Track Order',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }
}

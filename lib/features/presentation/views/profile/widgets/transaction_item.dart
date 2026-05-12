import 'package:clean_commerce/features/domain/entity/transaction_entity.dart';
import 'package:clean_commerce/features/presentation/views/profile/ordertrack_screen.dart';
import 'package:clean_commerce/features/presentation/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;
  final bool isTransaction;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.isTransaction = false,
  });

  Color _getColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_outlined;
      case 'completed':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formattedDate = transaction.date == null
        ? "Null"
        : DateFormat('MMM dd, yyyy').format(transaction.date!);
    final status = transaction.status;
    final statusColor = _getColor(status.name);
    final statusIcon = _getIcon(status.name);

    return ListTile(
      leading: StatusIcon(
        icon: statusIcon,
        color: statusColor,
        size: 20,
        padding: 8,
      ),
      title: Text(
        transaction.id,
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
          StatusChip(label: status.name, color: statusColor, compact: true),
        ],
      ),
      trailing: _buildTrailing(context, theme, colorScheme),
    );
  }

  Column _buildTrailing(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '\$${transaction.amount.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        TextButton(
          onPressed: isTransaction
              ? null
              : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        OrderTrackingScreen(orderId: transaction.id),
                  ),
                ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            isTransaction ? 'See Detail' : 'Track Order',
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

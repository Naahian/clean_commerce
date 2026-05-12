import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/domain/entity/transaction_entity.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RecentOrdersScreen extends StatelessWidget {
  RecentOrdersScreen({super.key});

  final List<TransactionEntity> transactions = [
    TransactionEntity(
      id: 'TRX-001',
      userId: '1',
      type: TransactionType.payment.name,
      amount: 125.50,
      status: TransactionStatus.completed,
      date: DateTime(2024, 1, 15),
    ),
    TransactionEntity(
      id: 'TRX-002',
      userId: '1',
      type: TransactionType.payment.name,
      amount: 89.99,
      status: TransactionStatus.completed,
      date: DateTime(2024, 1, 10),
    ),
    TransactionEntity(
      id: 'TRX-003',
      userId: '1',
      type: TransactionType.payment.name,
      amount: 245.00,
      status: TransactionStatus.pending,
      date: DateTime(2024, 1, 5),
    ),
    TransactionEntity(
      id: 'TRX-004',
      userId: '1',
      type: TransactionType.payment.name,
      amount: 45.50,
      status: TransactionStatus.rejected,
      date: DateTime(2024, 1, 1),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Orders"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Column(
          children: [
            // Filter by date section
            _filterByDate(colorScheme, theme),

            // Orders list
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) =>
                    TransactionItem(transaction: transactions[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _filterByDate(ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withAlpha(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_alt_outlined,
                size: 18.sp,
                color: colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'Filter by date',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          _buildDropdown(theme),
        ],
      ),
    );
  }

  Container _buildDropdown(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(30),
          width: 0.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: 2,
          icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
          items: [
            DropdownMenuItem(value: 1, child: Text("Last Week")),
            DropdownMenuItem(value: 2, child: Text("Last Month")),
            DropdownMenuItem(value: 3, child: Text("Last 3 Months")),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }
}

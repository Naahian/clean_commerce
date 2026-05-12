import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String _selectedPaymentMethod = 'Cash on Delivery';

  final List<Map<String, dynamic>> _paymentMethods = const [
    {
      'icon': Icons.account_balance_wallet_outlined,
      'name': 'bKash',
      'color': Colors.pink,
    },
    {
      'icon': Icons.delivery_dining_outlined,
      'name': 'Cash on Delivery',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: 2.w,
      runSpacing: 2.h,
      children: _paymentMethods.map((method) {
        final isSelected = _selectedPaymentMethod == method['name'];
        final color = method['color'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPaymentMethod = method['name'];
            });
          },
          child: Container(
            width: 28.w,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: isSelected ? color.withAlpha(20) : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : colorScheme.outline.withAlpha(20),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  method['icon'],
                  size: 30,
                  color: isSelected ? color : Colors.grey,
                ),
                SizedBox(height: 1.h),
                Text(
                  method['name'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected ? color : Colors.grey,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

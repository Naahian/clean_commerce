import 'package:clean_commerce/features/presentation/views/cart/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShippingCard extends StatelessWidget {
  final ShippingInfo shippingInfo;
  const ShippingCard({super.key, required this.shippingInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryFixedDim.withAlpha(50),
            colorScheme.tertiaryFixedDim.withAlpha(50),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withAlpha(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildShippingRow(theme, Icons.person_outline, shippingInfo.name),
          SizedBox(height: 2.h),
          _buildShippingRow(theme, Icons.phone_outlined, shippingInfo.phone),
          SizedBox(height: 2.h),
          _buildShippingRow(
            theme,
            Icons.location_on_outlined,
            shippingInfo.address,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingRow(ThemeData theme, IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        SizedBox(width: 3.w),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}

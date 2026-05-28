import 'package:clean_commerce/core/constansts.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MethodCard extends StatelessWidget {
  const MethodCard({
    super.key,
    required this.isSelected,
    required this.color, required this.method,
  });

  final bool isSelected;
  final dynamic color;
  final PaymentMethod method;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
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
            method.icon,
            size: 30,
            color: isSelected ? color : Colors.grey,
          ),
          SizedBox(height: 1.h),
          Text(
            method.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? color : Colors.grey,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

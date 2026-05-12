import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OrderProgress extends StatelessWidget {
  final int progress;
  const OrderProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(color: colorScheme.primary.withOpacity(0.05)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProgressStep(theme, 1, 'Cart', progress >= 1),
          _buildProgressLine(progress >= 2),
          _buildProgressStep(theme, 2, 'Checkout', progress >= 2),
          _buildProgressLine(progress >= 3),
          _buildProgressStep(theme, 3, 'Payment', progress == 3),
        ],
      ),
    );
  }

  Widget _buildProgressStep(
    ThemeData theme,
    int step,
    String label,
    bool isActive,
  ) {
    return Column(
      children: [
        Container(
          width: 14.w,
          height: 4.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.grey.shade300,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isActive ? Colors.green : Colors.grey.shade500,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      width: 18.w,
      height: 1,
      margin: EdgeInsets.only(bottom: 2.h),
      color: isActive ? Colors.green : Colors.grey.shade300,
    );
  }
}

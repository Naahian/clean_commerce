import 'package:clean_commerce/features/presentation/views/home/widgets/productdetail_widgets/quantity_counter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CartItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItem({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: colorScheme.outline.withAlpha(15)),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.sp),
            child: Image.network(
              item['image'],
              width: 20.w,
              height: 20.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 20.w,
                  height: 20.w,
                  color: Colors.grey.shade200,
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          SizedBox(width: 3.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '\$${item['price'].toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 1.h),
                QuantityCounter(
                  quantity: 1,
                  colorScheme: colorScheme,
                  onQuantityChanged: onQuantityChanged,
                ),
              ],
            ),
          ),
          // Remove button
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.delete_outline,
              size: 18,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        padding: EdgeInsets.all(2.w),
        constraints: const BoxConstraints(),
      ),
    );
  }
}

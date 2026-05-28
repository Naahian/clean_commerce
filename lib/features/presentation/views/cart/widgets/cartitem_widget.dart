import 'package:clean_commerce/features/presentation/viewmodels/cart_controller.dart';
import 'package:clean_commerce/features/presentation/viewmodels/models/cart_item.dart';
import 'package:clean_commerce/features/presentation/viewmodels/settings_notifier.dart';
import 'package:clean_commerce/features/presentation/views/home/widgets/productdetail_widgets/quantity_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CartItemWidget extends ConsumerWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(cartProvider.notifier);
    final productId = item.product.id;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final image = item.product.images.first;
    final name = item.product.name;
    final price = item.product.price;

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
              image,
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
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Consumer(
                  builder: (_, ref, _) {
                    final currency = ref.read(currencyProvider);
                    return Text(
                      '$currency${price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                ),
                SizedBox(height: 1.h),

                QuantityCounter(
                  quantity: item.quantity,
                  onQuantityChanged: (qty) =>
                      ctrl.updateQuantity(productId, qty),
                ),
              ],
            ),
          ),
          // Remove button
          IconButton(
            onPressed: () => ctrl.removeFromCart(item.product.id),
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
}

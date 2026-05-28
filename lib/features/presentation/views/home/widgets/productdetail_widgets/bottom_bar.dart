import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/cart_controller.dart';
import 'package:clean_commerce/features/presentation/views/home/widgets/productdetail_widgets/productdetail_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class ProductBottomBar extends ConsumerStatefulWidget {
  final ProductEntity product;

  const ProductBottomBar({super.key, required this.product});

  @override
  ConsumerState<ProductBottomBar> createState() => _ProductBottomBarState();
}

class _ProductBottomBarState extends ConsumerState<ProductBottomBar> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cartCtrl = ref.read(cartProvider.notifier);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            QuantityCounter(
              onQuantityChanged: (quantity) {
                setState(() {
                  _quantity = quantity;
                });
              },
              quantity: _quantity,
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () =>
                    cartCtrl.addToCart(widget.product, quantity: _quantity),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

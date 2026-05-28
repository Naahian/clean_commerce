import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final bool isBig;
  final ProductEntity product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    this.isBig = false,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pDiscount = product.discount == 0 ? 1 : product.discount ?? 0;
    final newPrice = (product.price * ((100 - pDiscount) / 100))
        .toStringAsPrecision(3);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 48.h,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: Colors.grey.withAlpha(20)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(005),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildImage(product.images.first),

                _buildOffer(colorScheme, theme),
              ],
            ),
            _buildInfo(
              theme,
              colorScheme,
              title: product.name,
              category: product.category ?? ".",
              price: newPrice,
              oldPrice: '${product.price}',
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildInfo(
    ThemeData theme,
    ColorScheme colorScheme, {
    required String title,
    required String category,
    required String price,
    required String oldPrice,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Consumer(
            builder: (_, ref, _) {
              final currency = ref.read(currencyProvider);
              return Row(
                children: [
                  Text(
                    '$currency$price',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$currency$oldPrice',
                    style: theme.textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: colorScheme.onSurface.withAlpha(50),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Positioned _buildOffer(ColorScheme colorScheme, ThemeData theme) {
    return Positioned(
      top: 2.h,
      left: 4.w,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isBig ? 4.w : 2.w,
          vertical: isBig ? 2.w : 1.w,
        ),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          '-20%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onPrimary,
            fontSize: isBig ? 15.sp : 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return AspectRatio(
      aspectRatio: 4 / 3, // Adjust as needed (width/height)
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
              value: progress.progress,
            ),
          ),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error, color: Colors.grey)),
        ),
      ),
    );
  }
}

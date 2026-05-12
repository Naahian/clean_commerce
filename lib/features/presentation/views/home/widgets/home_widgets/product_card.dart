import 'package:clean_commerce/features/presentation/views/home/productdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  final bool isBig;
  const ProductCard({super.key, this.isBig = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: "1")),
      ),
      child: Container(
        width: 180,
        height: 48.h,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border.all(color: Colors.grey.withAlpha(20)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                _buildImage(
                  "https://picsum.photos/id/${20 + DateTime.now().millisecondsSinceEpoch % 50}/400/300",
                ),

                _buildOffer(colorScheme, theme),
              ],
            ),
            _buildInfo(
              theme,
              colorScheme,
              title: 'A Long Product Name',
              category: 'Category',
              price: '59.99',
              oldPrice: '99.99',
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
          Row(
            children: [
              Text(
                '\$$price',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$$oldPrice',
                style: theme.textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
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

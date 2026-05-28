import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import 'widgets/productdetail_widgets/productdetail_widgets.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSection(
              colorScheme: colorScheme,
              images: product.images, // Pass product
            ),
            _ProductBodySection(
              theme: theme,
              colorScheme: colorScheme,
              quantity: product.quantity,
              product: product, // Pass product
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductBottomBar(product: product),
    );
  }
}

// ============================================================================
// Product Body Section
// ============================================================================

class _ProductBodySection extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final int quantity;
  final dynamic product;

  const _ProductBodySection({
    required this.theme,
    required this.colorScheme,
    required this.quantity,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildName(),
          SizedBox(height: 2.h),
          _ProductPriceSection(
            theme: theme,
            colorScheme: colorScheme,
            product: product,
          ),
          SizedBox(height: 2.h),
          _ProductStockInfo(theme: theme, product: product),
          SizedBox(height: 2.5.h),
          ProductTagsSection(
            theme: theme,
            colorScheme: colorScheme,
            product: product,
          ),
          SizedBox(height: 2.5.h),
          _ProductDescription(theme: theme, product: product),
          SizedBox(height: 5.h),
        ],
      ),
    );
  }

  Text _buildName() {
    return Text(
      product.name,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
    );
  }
}

// ============================================================================
// Price Section
// ============================================================================

class _ProductPriceSection extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic product;

  const _ProductPriceSection({
    required this.theme,
    required this.colorScheme,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate discounted price if applicable
    final hasDiscount = product.discount != null && product.discount! > 0;
    final originalPrice = product.price;
    final discountedPrice = hasDiscount
        ? originalPrice * (1 - (product.discount! / 100))
        : originalPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 0.5.h),
        Consumer(
          builder: (_, ref, _) {
            String currency = ref.read(currencyProvider);
            return Row(
              children: [
                Text(
                  '$currency${discountedPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                if (hasDiscount) ...[
                  SizedBox(width: 2.w),
                  Text(
                    '$currency${originalPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${product.discount}% OFF',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

// ============================================================================
// Stock Information
// ============================================================================

class _ProductStockInfo extends StatelessWidget {
  final ThemeData theme;
  final dynamic product;

  const _ProductStockInfo({required this.theme, required this.product});

  @override
  Widget build(BuildContext context) {
    final isInStock = product.quantity > 0;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isInStock ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isInStock ? '${product.quantity} items in stock' : 'Out of stock',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isInStock ? Colors.green[700] : Colors.red[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Product Description
// ============================================================================

class _ProductDescription extends StatelessWidget {
  final ThemeData theme;
  final dynamic product;

  const _ProductDescription({required this.theme, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          product.description ?? 'No description available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Product Tags Section
// ============================================================================

class ProductTagsSection extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;
  final dynamic product;

  const ProductTagsSection({super.key, 
    required this.theme,
    required this.colorScheme,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // Extract tags from metadata
    final metadata = product.metadata;
    final List<String> tags = metadata?['tags'] != null
        ? List<String>.from(metadata['tags'])
        : [];

    if (tags.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

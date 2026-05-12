import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import 'widgets/productdetail_widgets/productdetail_widgets.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

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
              isFavorite: _isFavorite,
              onFavoriteToggle: () =>
                  setState(() => _isFavorite = !_isFavorite),
            ),
            _ProductBodySection(
              theme: theme,
              colorScheme: colorScheme,
              quantity: _quantity,
              onQuantityChanged: (newQuantity) =>
                  setState(() => _quantity = newQuantity),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductBottomBar(
        theme: theme,
        colorScheme: colorScheme,
        quantity: _quantity,
        onQuantityChanged: (newQuantity) =>
            setState(() => _quantity = newQuantity),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey[600],
          size: 24,
        ),
        padding: const EdgeInsets.all(8),
      ),
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
  final Function(int) onQuantityChanged;

  const _ProductBodySection({
    required this.theme,
    required this.colorScheme,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wireless Headphones',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          SizedBox(height: 2.h),
          _ProductPriceSection(theme: theme, colorScheme: colorScheme),
          SizedBox(height: 2.h),
          _ProductStockInfo(theme: theme),
          SizedBox(height: 2.5.h),
          ProductTagsSection(theme: theme, colorScheme: colorScheme),
          SizedBox(height: 2.5.h),
          _ProductDescription(theme: theme),
          SizedBox(height: 5.h),
        ],
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

  const _ProductPriceSection({required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
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
        Text(
          '\$79.99',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
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

  const _ProductStockInfo({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '10 items in stock',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.green[700],
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

  const _ProductDescription({required this.theme});

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
          'High-quality wireless headphones with active noise cancellation, '
          '20-hour battery life, and ergonomic design. Perfect for music lovers, '
          'professionals, and everyday use.',
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

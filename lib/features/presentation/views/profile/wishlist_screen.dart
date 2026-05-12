import 'package:clean_commerce/features/domain/entity/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  final List<ProductEntity> wishlistItems = const [
    ProductEntity(
      id: '1',
      name: 'Wireless Headphones',
      price: 79.99,
      images: ['https://picsum.photos/id/20/200/200'],
      category: 'Electronics',
      ownerId: '',
      quantity: 1,
    ),
    ProductEntity(
      id: '2',
      name: 'Smart Watch',
      price: 199.99,
      images: ['https://picsum.photos/id/21/200/200'],
      category: 'Fashion',
      ownerId: '',
      quantity: 1,
    ),
    ProductEntity(
      id: '3',
      name: 'Phone Case',
      price: 19.99,
      images: ['https://picsum.photos/id/22/200/200'],
      category: 'Accessories',
      ownerId: '',
      quantity: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (wishlistItems.isNotEmpty)
            TextButton(
              onPressed: () {},
              child: Text(
                'Clear All',
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      ),
      body: wishlistItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Your wishlist is empty',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final product = wishlistItems[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.images[0],
                      width: 15.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 15.w,
                          height: 15.w,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite, color: Colors.red, size: 20),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 1.h),
                );
              },
            ),
    );
  }
}

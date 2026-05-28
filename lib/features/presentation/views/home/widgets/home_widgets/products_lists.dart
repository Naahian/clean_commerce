// product_card.dart
import 'package:clean_commerce/features/presentation/viewmodels/home_controller.dart';
import 'package:clean_commerce/features/presentation/views/home/productdetail_screen.dart';
import 'package:clean_commerce/features/presentation/views/home/widgets/home_widgets/product_card.dart';
import 'package:clean_commerce/features/presentation/widgets/shimmerbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class TrendingProducts extends ConsumerWidget {
  const TrendingProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final products = state.trendingProducts;

    return SizedBox(
      height: 34.h,
      child: state.isLoading
          ? _buildShimmers()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(6.w, 0, 6.w, 3.w),
              itemCount: 4,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: ProductCard(
                    isBig: true,
                    product: product,
                    onTap: () {
                      ref
                          .read(homeControllerProvider.notifier)
                          .selectProduct(product);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  ListView _buildShimmers() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        3,
        (_) => Padding(
          padding: EdgeInsets.fromLTRB(3.h, 0, 0, 2.h),
          child: Shimmerbox(width: 45.w),
        ),
      ),
    );
  }
}

class AllProducts extends ConsumerWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final products = state.fetchedProducts;

    return SliverPadding(
      padding: EdgeInsets.all(6.w),
      sliver: state.isLoading
          ? _buildShimmers()
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: EdgeInsets.only(top: 4.w),
                    child: SizedBox(
                      child: ProductCard(
                        isBig: true,
                        product: product,
                        onTap: () {
                          ref
                              .read(homeControllerProvider.notifier)
                              .selectProduct(product);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                childCount: products.length, // Your actual item count
              ),
            ),
    );
  }

  SliverPadding _buildNotFound() {
    return SliverPadding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10.h),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Center(child: Icon(Icons.inventory_2, size: 40, color: Colors.grey)),
          Center(child: Text("No Products Found", style: TextStyle(height: 2))),
        ]),
      ),
    );
  }

  SliverList _buildShimmers() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: 4, (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
          child: Shimmerbox(width: 40.w, height: 42.h),
        );
      }),
    );
  }
}

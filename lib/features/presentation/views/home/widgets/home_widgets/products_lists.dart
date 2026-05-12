// product_card.dart
import 'package:clean_commerce/features/presentation/views/home/widgets/home_widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrendingProducts extends StatelessWidget {
  const TrendingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(6.w, 0, 6.w, 3.w),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: ProductCard(),
          );
        },
      ),
    );
  }
}

class AllProducts extends StatelessWidget {
  final bool isOffline = false;

  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(6.w),
      sliver: isOffline
          ? _buildNotFound()
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 4.w),
                    child: SizedBox(child: const ProductCard(isBig: true)),
                  );
                },
                childCount: 10, // Your actual item count
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
}

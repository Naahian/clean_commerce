// ignore_for_file: public_member_api_docs, sort_constructors_first
// profile_stats.dart
import 'package:clean_commerce/features/presentation/views/profile/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfileStats extends StatelessWidget {
  final int totalOrders;
  final double totalSpent;
  final int wishlistCount;

  const ProfileStats({
    super.key,
    required this.totalOrders,
    required this.totalSpent,
    required this.wishlistCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            value: totalOrders.toString(),
            label: "Orders",
            icon: Icons.shopping_bag_outlined,
          ),
          _divider(colorScheme),
          _StatItem(
            value: "\$${totalSpent.toStringAsFixed(0)}",
            label: "Spent",
            icon: Icons.attach_money_outlined,
          ),
          _divider(colorScheme),
          _StatItem(
            value: wishlistCount.toString(),
            label: "Wishlist",
            icon: Icons.favorite_border,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => WishlistScreen())),
          ),
        ],
      ),
    );
  }

  Container _divider(ColorScheme colorScheme) {
    return Container(
      width: 1,
      height: 15.w,
      color: colorScheme.outline.withAlpha(50),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _StatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.sp),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          20.sp,
        ), // Add borderRadius to InkWell
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: onTap == null
                ? null
                : Border.all(color: colorScheme.primary.withAlpha(50)),
            borderRadius: BorderRadius.circular(20.sp),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22.sp, color: colorScheme.primary),
              SizedBox(height: 1.h),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

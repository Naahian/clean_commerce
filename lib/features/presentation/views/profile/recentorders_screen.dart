import 'package:clean_commerce/features/domain/entities/order_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/transaction_controller.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/transaction_item.dart';
import 'package:clean_commerce/features/presentation/widgets/shimmerbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class RecentOrdersScreen extends ConsumerStatefulWidget {
  const RecentOrdersScreen({super.key});

  @override
  ConsumerState<RecentOrdersScreen> createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends ConsumerState<RecentOrdersScreen> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(orderProvider.notifier).fetchRecentOrders(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(orderProvider);
    final order = state.orders;

    return Scaffold(
      appBar: AppBar(title: const Text("Orders"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: state.isLoading
            ? _buildShimmers()
            : state.hasOrders
            ? _buildOrderList(colorScheme, theme, order)
            : _buildNoOrderCard(theme),
      ),
    );
  }

  Center _buildNoOrderCard(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 30.sp,
            color: theme.colorScheme.onSurface.withAlpha(150),
          ),
          SizedBox(height: 2.h),
          Text(
            "No orders found",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildShimmers() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
          child: Shimmerbox(
            width: double.maxFinite,
            height: 8.h,
            borderRadius: 12,
          ),
        );
      },
    );
  }

  Column _buildOrderList(
    ColorScheme colorScheme,
    ThemeData theme,
    List<OrderEntity> order,
  ) {
    return Column(
      children: [
        SizedBox(height: 2.h),
        Text(
          "Showing Recent (max 10) orders.",
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
          ),
        ),
        SizedBox(height: 4.h),
        Expanded(
          child: ListView.builder(
            itemCount: order.length,
            itemBuilder: (context, index) {
              return TileInfoItem(order: order[index]);
            },
          ),
        ),
      ],
    );
  }
}

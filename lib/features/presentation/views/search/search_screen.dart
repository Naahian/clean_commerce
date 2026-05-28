import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/search_controller.dart';
import 'package:clean_commerce/features/presentation/views/home/productdetail_screen.dart';
import 'package:clean_commerce/features/presentation/views/home/widgets/home_widgets/product_card.dart';
import 'package:clean_commerce/features/presentation/widgets/appdarawer.dart';
import 'package:clean_commerce/features/presentation/widgets/bottomnavbar.dart';
import 'package:clean_commerce/features/presentation/widgets/shimmerbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'widgets/widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ctrl = ref.read(searchControllerProvider.notifier);
    final state = ref.watch(searchControllerProvider);
    final products = state.filteredProducts;

    scrollController.addListener(() {
      final pos = scrollController.position.pixels;
      final max = scrollController.position.maxScrollExtent;
      if (pos == max) ctrl.loadMore();
    });

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      drawer: CustomDrawer(),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: const Text('Search'),
            centerTitle: true,
            pinned: true,
            floating: true,
            expandedHeight: 38.h,
            flexibleSpace: _buildSearchFilter(colorScheme),
          ),
          state.isLoading ? _buildShimmers() : _buildResult(products),
          if (state.isLoadingMore) _buildShimmers(),
          SliverToBoxAdapter(child: SizedBox(height: 2.h)),
        ],
      ),
    );
  }

  SliverList _buildResult(List<ProductEntity> products) {
    return SliverList.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: EdgeInsets.all(2.h),
          child: ProductCard(
            isBig: true,
            product: product,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: product),
                ),
              );
            },
          ),
        );
      },
    );
  }

  SliverList _buildShimmers() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: 2, (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
          child: Shimmerbox(width: 40.w, height: 42.h),
        );
      }),
    );
  }

  FlexibleSpaceBar _buildSearchFilter(ColorScheme colorScheme) {
    return FlexibleSpaceBar(
      background: Container(
        padding: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: colorScheme.surface),
            BoxShadow(color: colorScheme.primary.withAlpha(17)),
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Searchbar(),
            Padding(
              padding: EdgeInsets.only(left: 6.w, top: 1.h),
              child: Text("Filter By Price"),
            ),
            PriceFilter(),
            Padding(
              padding: EdgeInsets.only(left: 6.w, top: 1.h),
              child: Text("Filter By Category"),
            ),
            CategoryFilter(),
          ],
        ),
      ),
    );
  }

  Center _notFound(ColorScheme colorScheme, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 40,
            color: colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          SizedBox(height: 2.h),
          Text(
            'Search for products',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

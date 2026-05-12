import 'package:clean_commerce/features/presentation/views/home/widgets/home_widgets/product_card.dart';
import 'package:clean_commerce/features/presentation/views/search/widgets/category_filter.dart';
import 'package:clean_commerce/features/presentation/views/search/widgets/price_filter.dart';
import 'package:clean_commerce/features/presentation/views/search/widgets/search_bar.dart';
import 'package:clean_commerce/features/presentation/widgets/appdarawer.dart';
import 'package:clean_commerce/features/presentation/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            title: const Text('Search'),
            centerTitle: true,
            pinned: true,
            floating: true,
            expandedHeight: 38.h,
            flexibleSpace: FlexibleSpaceBar(
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
            ),
          ),
          SliverList.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(2.h),
                child: const ProductCard(),
              );
            },
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(22.sp),
              child: OutlinedButton(onPressed: () {}, child: Text("Show More")),
            ),
          ),
        ],
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

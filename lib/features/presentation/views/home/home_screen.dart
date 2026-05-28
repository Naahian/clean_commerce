import 'package:clean_commerce/features/presentation/viewmodels/home_controller.dart';
import 'package:clean_commerce/features/presentation/widgets/bottomnavbar.dart';
import 'package:clean_commerce/features/presentation/widgets/shimmerbox.dart';
import 'package:flutter/material.dart';
import 'package:clean_commerce/features/presentation/views/home/widgets/home_widgets/appbar.dart';
import 'package:clean_commerce/features/presentation/widgets/appdarawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/home_widgets/home_widgets.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: Appbar(),
      drawer: const CustomDrawer(),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.w),
                const CarouselWidget(),
                SizedBox(height: 6.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Text(
                    'Categories',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                SizedBox(height: 4.w),
                const CategoriesWidget(),
                SizedBox(height: 6.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Text('Trending', style: theme.textTheme.headlineSmall),
                ),
                SizedBox(height: 6.w),
                const TrendingProducts(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text('Browse Items', style: theme.textTheme.headlineSmall),
            ),
          ),
          AllProducts(),
          _buildLoadMore(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildLoadMore() => SliverToBoxAdapter(
    child: Consumer(
      builder: (context, ref, _) {
        final ctrl = ref.read(homeControllerProvider.notifier);
        final state = ref.read(homeControllerProvider);

        return state.moreLoading ? _buildShimmers() : _loadMoreBtn(ctrl);
      },
    ),
  );

  Column _buildShimmers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        2,
        (_) => Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
          child: Shimmerbox(width: 40.w, height: 40.h),
        ),
      ),
    );
  }

  Padding _loadMoreBtn(HomeController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 140),
      child: OutlinedButton(
        onPressed: () => ctrl.loadMoreProducts(),
        child: const Text("Load More"),
      ),
    );
  }
}

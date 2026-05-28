import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/presentation/viewmodels/search_controller.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  void checkAnyFilterChange(SearchController ctrl) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ctrl.onAnyFilterChange(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categories = Categories.values;
    final ctrl = ref.read(searchControllerProvider.notifier);
    final state = ref.watch(searchControllerProvider);
    // checkAnyFilterChange(ctrl);

    return SizedBox(
      height: 6.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: Categories.values.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = state.selectedCategory == category.name;
          final color = category.color;

          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                category.name,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
              onSelected: (selected) {
                ctrl.filterByCategory(category.name);
              },
              backgroundColor: color.withAlpha(60),
              selectedColor: color,
              labelStyle: TextStyle(color: isSelected ? Colors.white : color),
              side: BorderSide(
                color: isSelected ? Colors.transparent : color.withOpacity(0.5),
                width: 1,
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              shape: StadiumBorder(),
            ),
          );
        },
      ),
    );
  }
}

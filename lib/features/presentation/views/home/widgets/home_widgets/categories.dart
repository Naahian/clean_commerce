// categories_widget.dart
import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/presentation/viewmodels/search_controller.dart';
import 'package:clean_commerce/features/presentation/views/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = Categories.values.sublist(1);
    return SizedBox(
      height: 11.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: _buildCategoryBtn(category, theme),
          );
        },
      ),
    );
  }

  Consumer _buildCategoryBtn(Categories category, ThemeData theme) {
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen()),
            );
            ref
                .read(searchControllerProvider.notifier)
                .filterByCategory(category.name);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [category.color, category.color.withAlpha(70)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: category.color.withAlpha(30),
                      blurRadius: 10,
                      offset: Offset(0, 1.5.h),
                    ),
                  ],
                ),
                child: Icon(category.icon, color: Colors.white, size: 23.sp),
              ),
              Text(
                category.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

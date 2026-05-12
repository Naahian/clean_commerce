// categories_widget.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Electronics',
      'icon': Icons.electrical_services,
      'color': 0xFF4CAF50,
    },
    {'name': 'Fashion', 'icon': Icons.checkroom, 'color': 0xFF2196F3},
    {'name': 'Home', 'icon': Icons.home_work, 'color': 0xFFFF9800},
    {'name': 'Beauty', 'icon': Icons.spa, 'color': 0xFFE91E63},
    {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': 0xFF9C27B0},
    {'name': 'Books', 'icon': Icons.book, 'color': 0xFF673AB7},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      colors: [
                        Color(category['color']),
                        Color(category['color']).withAlpha(70),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(category['color']).withAlpha(30),
                        blurRadius: 10,
                        offset: Offset(0, 1.5.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    category['icon'],
                    color: Colors.white,
                    size: 23.sp,
                  ),
                ),
                Text(
                  category['name'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

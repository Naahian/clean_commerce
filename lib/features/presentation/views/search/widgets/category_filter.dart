import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({super.key});

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  String _selectedCategory = 'Electronics';

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
      height: 6.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['name'];
          final color = Color(category['color']);

          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                category['name'],
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected
                      ? category['name']
                      : _selectedCategory;
                });
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

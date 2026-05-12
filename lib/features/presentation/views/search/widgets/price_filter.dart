import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PriceFilter extends StatefulWidget {
  const PriceFilter({super.key});

  @override
  State<PriceFilter> createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  final List<String> _filters = const [
    'Price: Lowest First',
    'Price: Highest First',
    'On Sale',
  ];
  String _selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 1.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_filters.length, (index) {
            final filter = _filters[index];
            final isSelected = _selectedFilter == filter;

            return Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: FilterChip(
                label: Text(filter, style: TextStyle(fontSize: 14.sp)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? filter : '';
                  });
                },
                backgroundColor: colorScheme.secondary.withAlpha(30),
                selectedColor: colorScheme.primary.withAlpha(80),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: colorScheme.onSurface,
                ),
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : Colors.grey.shade300,
                  width: 0.5,
                ),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0),
              ),
            );
          }),
        ),
      ),
    );
  }
}

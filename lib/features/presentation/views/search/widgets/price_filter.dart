import 'package:clean_commerce/features/presentation/viewmodels/search_controller.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class PriceFilter extends ConsumerWidget {
  const PriceFilter({super.key});

  void checkAnyFilterChange(SearchController ctrl) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ctrl.onAnyFilterChange(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ctrl = ref.read(searchControllerProvider.notifier);
    final state = ref.watch(searchControllerProvider);
    final filters = PriceFilters.values;
    final filter = state.priceFilter;
    // checkAnyFilterChange(ctrl);

    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 1.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (index) {
            final filterName = filters[index].name;
            final isSelected = filter.name == filterName;

            return Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: FilterChip(
                label: Text(filterName, style: TextStyle(fontSize: 14.sp)),
                selected: isSelected,
                onSelected: (selected) {
                  ctrl.filterByPrice(filters[index]);
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

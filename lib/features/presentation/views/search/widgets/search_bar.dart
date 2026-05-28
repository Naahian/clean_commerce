import 'package:clean_commerce/features/presentation/viewmodels/search_controller.dart';
import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class Searchbar extends ConsumerStatefulWidget {
  const Searchbar({super.key});

  @override
  ConsumerState<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends ConsumerState<Searchbar> {
  final TextEditingController _searchController = TextEditingController();

  void checkAnyFilterChange(SearchController ctrl) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ctrl.onAnyFilterChange(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ctrl = ref.read(searchControllerProvider.notifier);
    // checkAnyFilterChange(ctrl);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
            prefixIcon: Icon(
              Icons.search,
              size: 18,
              color: colorScheme.primary,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      ctrl.clearFilters();
                    },
                    icon: Icon(Icons.clear, size: 16),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: 1.h,
              horizontal: 2.w,
            ),
          ),

          onChanged: (value) => ctrl.filterBySearch(value),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/presentation/snackbar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// STATES
// =============================================================

enum PriceFilters { none, lowestFirst, highestFirst }

class SearchState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<ProductEntity> products; // fetched products
  final List<ProductEntity> filteredProducts; // Currently displayed
  final String searchQuery;
  final String selectedCategory;
  final PriceFilters priceFilter;
  final List<String> categories;
  final bool hasMore; // Whether more products exist on server
  final String? errorMessage;

  const SearchState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.products = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.priceFilter = PriceFilters.none,
    this.categories = const [],
    this.hasMore = true,
    this.errorMessage,
  });

  SearchState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<ProductEntity>? products,
    List<ProductEntity>? filteredProducts,
    String? searchQuery,
    String? selectedCategory,
    PriceFilters? priceFilter,
    List<String>? categories,
    bool? hasMore,
    String? errorMessage,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      priceFilter: priceFilter ?? this.priceFilter,
      categories: categories ?? this.categories,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  int get resultCount => filteredProducts.length;
  bool get hasProducts => filteredProducts.isNotEmpty;
}

// PROVIDERS
// =============================================================

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => getIt<ProductRepository>(),
);

final snackbarProvider = Provider<SnackbarService>(
  (ref) => getIt<SnackbarService>(),
);

final searchControllerProvider =
    NotifierProvider<SearchController, SearchState>(() => SearchController());

// CONTROLLER
// =============================================================

class SearchController extends Notifier<SearchState> {
  late final ProductRepository _repository;
  late final SnackbarService _snackbar;

  // Track fetch offset for pagination
  int _currentOffset = 0;
  static const int _pageSize = 8;

  @override
  SearchState build() {
    _repository = ref.read(productRepositoryProvider);
    _snackbar = ref.read(snackbarProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialProducts();
    });

    return const SearchState(isLoading: true);
  }

  // PUBLIC FILTER METHODS
  // --------------------------------------------------------------------------

  Future<void> filterBySearch(String query) async {
    state = state.copyWith(
      searchQuery: query,
      isLoading: true,
      products: [],
      filteredProducts: [],
    );
    _currentOffset = 0;

    await _fetchAndFilterProducts(reset: true);
    state = state.copyWith(isLoading: false);
  }

  Future<void> filterByCategory(String category) async {
    state = state.copyWith(
      selectedCategory: category,
      isLoading: true,
      products: [],
      filteredProducts: [],
    );
    _currentOffset = 0;

    await _fetchAndFilterProducts(reset: true);
    state = state.copyWith(isLoading: false);
  }

  Future<void> filterByPrice(PriceFilters filter) async {
    state = state.copyWith(
      priceFilter: filter,
      isLoading: true,
      products: [],
      filteredProducts: [],
    );
    _currentOffset = 0;

    await _fetchAndFilterProducts(reset: true);
    state = state.copyWith(isLoading: false);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);

    final result = await _repository.getAll(
      limit: _pageSize,
      skip: _currentOffset,
    );

    if (result.success && result.data != null && result.data!.isNotEmpty) {
      // Add to existing products
      final allProducts = [...state.products, ...result.data!];
      _currentOffset += result.data!.length;

      state = state.copyWith(
        products: allProducts,
        isLoadingMore: false,
        hasMore: result.data!.length == _pageSize,
      );

      await _applyLocalFilters();
    } else if (result.success && result.data != null && result.data!.isEmpty) {
      state = state.copyWith(isLoadingMore: false, hasMore: false);
      _snackbar.showInfo("No more products");
    } else {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: result.message,
      );
      _snackbar.showError(result.message ?? "Failed to load more");
    }
  }

  Future<void> refresh() async {
    _currentOffset = 0;
    await _loadInitialProducts();
  }

  // apply update filters
  Future<void> onAnyFilterChange() async {
    if (state.priceFilter == PriceFilters.none &&
        state.selectedCategory == 'All' &&
        state.searchQuery.isEmpty) {
      return;
    }

    List filters = [
      state.priceFilter == PriceFilters.none,
      state.selectedCategory.isEmpty,
      state.searchQuery.isEmpty,
    ];
    if (filters.any((f) => f == true)) {
      await _applyLocalFilters();
    }
  }

  Future<void> clearFilters() async {
    state = state.copyWith(
      searchQuery: '',
      selectedCategory: 'All',
      priceFilter: PriceFilters.none,
      isLoading: true,
      products: [],
      filteredProducts: [],
    );
    _currentOffset = 0;

    await _fetchAndFilterProducts(reset: true);
    state = state.copyWith(isLoading: false);
    _snackbar.showSuccess("All filters cleared");
  }

  // PRIVATE METHODS
  // --------------------------------------------------------------------------

  Future<void> _loadInitialProducts() async {
    state = state.copyWith(isLoading: true);
    await _fetchAndFilterProducts(reset: true);
    state = state.copyWith(isLoading: false);
  }

  Future<void> _fetchAndFilterProducts({bool reset = true}) async {
    if (reset) {
      _currentOffset = 0;
    }

    final result = await _repository.getAll(
      limit: _pageSize,
      skip: _currentOffset,
    );

    if (result.success && result.data != null) {
      final newProducts = result.data!;
      _currentOffset += newProducts.length;

      state = state.copyWith(
        products: newProducts,
        hasMore: newProducts.length == _pageSize,
      );

      await _applyLocalFilters();
      await _ensureEnoughFilteredProducts();
    } else {
      state = state.copyWith(
        errorMessage: result.message,
        isLoading: false,
        isLoadingMore: false,
      );
      _snackbar.showError(result.message ?? "Failed to load products");
    }
  }

  Future<void> _applyLocalFilters() async {
    List<ProductEntity> filtered = List.from(state.products);

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(
              state.searchQuery.toLowerCase(),
            ) ||
            (product.description?.toLowerCase().contains(
                  state.searchQuery.toLowerCase(),
                ) ??
                false);
      }).toList();
    }

    // Apply category filter
    if (state.selectedCategory != 'All') {
      filtered = filtered.where((product) {
        return product.category?.toLowerCase() ==
            state.selectedCategory.toLowerCase();
      }).toList();
    }

    // Apply price filter
    switch (state.priceFilter) {
      case PriceFilters.lowestFirst:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case PriceFilters.highestFirst:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case PriceFilters.none:
        break;
    }

    state = state.copyWith(filteredProducts: filtered);
  }

  Future<void> _ensureEnoughFilteredProducts() async {
    // If no more to fetch
    if (state.filteredProducts.length >= _pageSize || !state.hasMore) {
      return;
    }

    final result = await _repository.getAll(
      limit: _pageSize,
      skip: _currentOffset,
    );

    if (result.success && result.data != null && result.data!.isNotEmpty) {
      final allProducts = [...state.products, ...result.data!];
      _currentOffset += result.data!.length;

      state = state.copyWith(
        products: allProducts,
        hasMore: result.data!.length == _pageSize,
      );

      await _applyLocalFilters();

      // Recursive check for more
      await _ensureEnoughFilteredProducts();
    }
  }
}

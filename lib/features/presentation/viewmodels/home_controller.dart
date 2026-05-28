import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/domain/entities/banner_entity.dart';
import 'package:clean_commerce/features/domain/entities/product_entity.dart';
import 'package:clean_commerce/features/domain/repositories/product_repo_imp.dart';
import 'package:clean_commerce/features/presentation/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// STATE
// ============================================================================

class HomeState {
  final bool isLoading;
  final bool moreLoading;
  final List<ProductEntity> fetchedProducts;
  final List<ProductEntity> trendingProducts;
  final List<BannerEntity> bannerItems;
  final ProductEntity? selectedProduct;

  const HomeState({
    this.isLoading = false,
    this.fetchedProducts = const [],
    this.trendingProducts = const [],
    this.bannerItems = const [],
    this.moreLoading = false,
    this.selectedProduct,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? moreLoading,
    List<ProductEntity>? fetchedProducts,
    List<ProductEntity>? trendingProducts,
    List<BannerEntity>? bannerItems,
    ProductEntity? selectedProduct,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      moreLoading: moreLoading ?? this.moreLoading,
      fetchedProducts: fetchedProducts ?? this.fetchedProducts,
      trendingProducts: trendingProducts ?? this.trendingProducts,
      bannerItems: bannerItems ?? this.bannerItems,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }

  bool get hasProducts => fetchedProducts.isNotEmpty;
  bool get hasTrending => trendingProducts.isNotEmpty;
}

// PROVIDERS
// ============================================================================

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

// CONTROLLER
// ============================================================================

class HomeController extends Notifier<HomeState> {
  late final ProductRepository _repository;
  late final SnackbarService _snackbar;

  @override
  HomeState build() {
    _repository = ref.read(productRepositoryProvider);
    _snackbar = ref.read(snackbarProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
    return const HomeState(isLoading: true);
  }

  // PUBLIC METHODS
  // --------------------------------------------------------------------------
  void selectProduct(ProductEntity product) {
    state = state.copyWith(selectedProduct: product);
  }

  Future<void> refresh() async {
    await _fetchAllData();
  }

  Future<void> loadMoreProducts() async {
    if (state.isLoading || state.moreLoading) return;
    state = state.copyWith(moreLoading: true);

    final skip = state.fetchedProducts.length;
    final result = await _repository.getAll(skip: skip);

    if (result.success && result.data != null && result.data!.isNotEmpty) {
      state = state.copyWith(
        fetchedProducts: [...state.fetchedProducts, ...result.data!],
        moreLoading: false,
      );
    } else if (result.success && result.data != null && result.data!.isEmpty) {
      // No more products to load
      state = state.copyWith(isLoading: false);
      _snackbar.showInfo("No more products to load");
    } else {
      // Error case
      state = state.copyWith(isLoading: false);
      _snackbar.showError(result.message ?? "Failed to load more products");
    }
    state = state.copyWith(moreLoading: false);
  }

  Future<void> _fetchInitialData() async {
    await _fetchAllData();
  }

  // PRIVATE METHODS
  // --------------------------------------------------------------------------

  Future<void> _fetchAllData() async {
    state = state.copyWith(isLoading: true);

    await Future.wait([
      _fetchFetchedProducts(),
      _fetchTrendingProducts(),
      _fetchBannerItems(),
    ]);

    state = state.copyWith(isLoading: false);
  }

  Future<void> _fetchFetchedProducts() async {
    final result = await _repository.getAll(limit: 10, skip: 0);
    if (result.success && result.data != null) {
      state = state.copyWith(fetchedProducts: result.data!);
    } else {
      _snackbar.showError(result.message ?? "Failed to load products");
      state = state.copyWith(fetchedProducts: []);
    }
  }

  Future<void> _fetchTrendingProducts() async {
    final result = await _repository.getTrendingProducts();
    if (result.success && result.data != null) {
      state = state.copyWith(trendingProducts: result.data!);
    } else {
      _snackbar.showError(result.message ?? "Failed to load trending products");
      state = state.copyWith(trendingProducts: []);
    }
  }

  Future<void> _fetchBannerItems() async {
    final result = await _repository.getBanners();

    if (result.success && result.data != null) {
      state = state.copyWith(bannerItems: result.data!);
    } else {
      _snackbar.showError(result.message ?? "Failed to load banners");

      final fallbackBanners = [
        BannerEntity(
          id: '1',
          title: 'Summer Sale',
          subtitle: 'Up to 50% off',
          tag: 'SALE',
          image: ApiEndpoints.fallBackimage,
        ),
        BannerEntity(
          id: '2',
          title: 'New Arrivals',
          subtitle: 'Shop now',
          tag: 'NEW',
          image: ApiEndpoints.fallBackimage,
        ),
        BannerEntity(
          id: '3',
          title: 'Free Shipping',
          subtitle: 'On orders over 50 taka',
          tag: 'OFFER',
          image: ApiEndpoints.fallBackimage,
        ),
      ];

      state = state.copyWith(bannerItems: fallbackBanners);
    }
  }
}

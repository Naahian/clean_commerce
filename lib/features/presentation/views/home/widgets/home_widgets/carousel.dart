// carousel_widget.dart
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/domain/entities/banner_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/home_controller.dart';
import 'package:clean_commerce/features/presentation/widgets/shimmerbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CarouselWidget extends ConsumerStatefulWidget {
  const CarouselWidget({super.key});

  @override
  ConsumerState<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends ConsumerState<CarouselWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeState = ref.watch(homeControllerProvider);
    final banners = homeState.bannerItems;

    final fallbackImg = ApiEndpoints.fallBackimage;
    final colors = [
      Colors.red.shade700,
      Colors.green.shade700,
      Colors.blue.shade700,
      Colors.purple.shade700,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          homeState.isLoading
              ? Shimmerbox(width: 100.w, height: 25.h)
              : _buildCarousel(banners, colors, fallbackImg),
          SizedBox(height: 1.h),
          _buildIndicator(banners, theme, _currentIndex),
        ],
      ),
    );
  }

  CarouselSlider _buildCarousel(
    List<BannerEntity> banners,
    List<Color> colors,
    String fallbackImg,
  ) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 25.h,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: banners.map((item) {
        final color = colors[Random().nextInt(colors.length)];

        return Container(
          width: 100.sw,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(horizontal: 0.8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: item.image ?? fallbackImg,
                  fit: BoxFit.cover,
                  color: color,
                  colorBlendMode: BlendMode.multiply,
                ),
              ),
              Positioned(
                right: -4.w,
                bottom: -4.h,
                child: Icon(
                  Icons.shopping_bag,
                  size: 50.sp,
                  color: Colors.white.withAlpha(70),
                ),
              ),
              _buildTitleSubtitle(item, color),
            ],
          ),
        );
      }).toList(),
    );
  }
}

Row _buildIndicator(List<BannerEntity> banners, ThemeData theme, int index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: banners.asMap().entries.map((entry) {
      return Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == entry.key
              ? theme.colorScheme.primary
              : Colors.grey.shade300,
        ),
      );
    }).toList(),
  );
}

Padding _buildTitleSubtitle(BannerEntity item, Color color) {
  return Padding(
    padding: EdgeInsets.all(5.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          item.subtitle,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
        SizedBox(height: 2.h),
      ],
    ),
  );
}

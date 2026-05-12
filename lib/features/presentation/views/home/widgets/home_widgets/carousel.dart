// carousel_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'image': 'https://picsum.photos/id/20/800/400',
      'title': 'Summer Sale',
      'subtitle': 'Up to 50% off',
      'color': Colors.deepOrange,
    },
    {
      'image': 'https://picsum.photos/id/26/800/400',
      'title': 'New Arrivals',
      'subtitle': 'Shop the latest trends',
      'color': Colors.purpleAccent,
    },
    {
      'image': 'https://picsum.photos/id/30/800/400',
      'title': 'Free Shipping',
      'subtitle': 'On orders over \$50',
      'color': Colors.greenAccent.shade700,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 25.h,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _carouselItems.map((item) {
            /// BACKGROUND, SIZE, DECORATION ///

            return Builder(
              builder: (BuildContext context) {
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

                  /// CHILDREN ITEMS  ///
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: item['image'],
                          fit: BoxFit.cover,
                          color: item['color'],
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

                      _buildTitleSubtitle(item),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        _buildIndicators(theme),
      ],
    );
  }

  Padding _buildTitleSubtitle(Map<String, dynamic> item) {
    return Padding(
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item['title'],
            style: TextStyle(color: Colors.white, fontSize: 22.sp),
          ),
          Text(
            item['subtitle'],
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Expanded(child: SizedBox()),
          _buildShopBtn(item),
        ],
      ),
    );
  }

  Widget _buildShopBtn(Map<String, dynamic> item) {
    return FilledButton(
      onPressed: () {
        //TODO: implement
      },
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
      child: Text(
        'Shop Now',
        style: TextStyle(color: item['color'], fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _buildIndicators(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _carouselItems.asMap().entries.map((entry) {
        return Container(
          width: 2.w,
          height: 2.h,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == entry.key
                ? theme.colorScheme.primary
                : Colors.grey[300],
          ),
        );
      }).toList(),
    );
  }
}

// carousel_widget.dart
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

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
      'color': Colors.orange,
    },
    {
      'image': 'https://picsum.photos/id/26/800/400',
      'title': 'New Arrivals',
      'subtitle': 'Shop the latest trends',
      'color': Colors.purple,
    },
    {
      'image': 'https://picsum.photos/id/30/800/400',
      'title': 'Free Shipping',
      'subtitle': 'On orders over \$50',
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
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
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [item['color'], item['color'].withOpacity(0.7)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          Icons.shopping_bag,
                          size: 120,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['subtitle'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Shop Now',
                                style: TextStyle(
                                  color: item['color'],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _carouselItems.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? theme.colorScheme.primary
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

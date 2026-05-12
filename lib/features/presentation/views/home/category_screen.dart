import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(6.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final color = Color(category['color']);

          return Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Ink(
              height: 12.h,
              decoration: BoxDecoration(
                color: color,
                image: DecorationImage(
                  image: NetworkImage(
                    "https://picsum.photos/id/${20 + DateTime.now().millisecondsSinceEpoch % 50}/400/300",
                  ),
                  opacity: 0.4,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withAlpha(60),
                    blurRadius: 10,
                    offset: const Offset(1, 5),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                splashColor: color.withAlpha(150),
                highlightColor: Colors.white.withAlpha(150),
                child: Stack(
                  children: [
                    Positioned(
                      right: -2.w,
                      bottom: -2.h,
                      child: Icon(
                        category['icon'],
                        size: 40.sp,
                        color: Colors.white.withAlpha(60),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category['icon'], size: 28, color: Colors.white),
                          SizedBox(width: 6.w),
                          Text(
                            category['name'],
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

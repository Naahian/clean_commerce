// categories_widget.dart
import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

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
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(category['color']),
                        Color(category['color']).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(category['color']).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(category['icon'], color: Colors.white, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductTagsSection extends StatelessWidget {
  final ThemeData theme;
  final ColorScheme colorScheme;

  const ProductTagsSection({super.key, required this.theme, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final tags = [
      'Noise Cancellation',
      'Long Battery',
      'Wireless',
      'Electronics',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.2.h),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.25),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

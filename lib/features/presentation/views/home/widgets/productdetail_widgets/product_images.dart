import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProductImageSection extends StatefulWidget {
  final ColorScheme colorScheme;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductImageSection({
    required this.colorScheme,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<ProductImageSection> createState() => _ProductImageSectionState();
}

class _ProductImageSectionState extends State<ProductImageSection> {
  int _selectedImageIndex = 0;

  final List<String> _images = [
    'https://picsum.photos/id/20/400/400',
    'https://picsum.photos/id/21/400/400',
    'https://picsum.photos/id/22/400/400',
    'https://picsum.photos/id/23/400/400',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main cover image
        Stack(
          children: [
            Container(
              height: 45.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.colorScheme.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Image.network(
                _images[_selectedImageIndex],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                      color: widget.colorScheme.primary.withOpacity(0.3),
                    ),
                  );
                },
              ),
            ),
            // Back button
            Positioned(
              top: 40,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  color: Colors.black87,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ),
            // Favorite button
            Positioned(
              top: 40,
              right: 16,
              child: _FavoriteButton(
                isFavorite: widget.isFavorite,
                onPressed: widget.onFavoriteToggle,
              ),
            ),
          ],
        ),
        // Thumbnail row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: List.generate(_images.length, (index) {
              final isSelected = _selectedImageIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImageIndex = index;
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.only(
                    right: index != _images.length - 1 ? 12 : 0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? widget.colorScheme.primary
                          : Colors.grey.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.image,
                            size: 24,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onPressed;

  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 20,
          color: isFavorite ? Colors.red : Colors.black87,
        ),
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}

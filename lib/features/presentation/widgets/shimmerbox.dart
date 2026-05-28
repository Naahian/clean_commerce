import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Shimmerbox extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  const Shimmerbox({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Shimmer.fromColors(
      baseColor: color.withAlpha(60),
      highlightColor: color.withAlpha(30),
      child: Container(
        width: width ?? double.maxFinite,
        height: height ?? double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
        ),
      ),
    );
  }
}

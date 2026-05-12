import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool compact;

  const StatusChip({
    super.key,
    required this.label,
    this.color = Colors.grey,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10.sp : 18.sp,
        vertical: compact ? 4.sp : 12.sp,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(30), width: 0.5),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: compact ? 10.sp : 14.sp,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class StatusIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double padding;

  const StatusIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 24,
    this.padding = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}

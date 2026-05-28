import 'package:flutter/material.dart';

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;
  CategoryItem({required this.name, required this.icon, required this.color});
  @override
  String toString() => 'CategoryItem(name: $name, icon: $icon, color: $color)';
}

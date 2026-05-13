// profile_header.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

import 'package:sizer/sizer.dart';

class ProfileHeader extends StatelessWidget {
  final bool isScrolled;
  final String username;
  final String fullName;

  const ProfileHeader({
    super.key,
    required this.isScrolled,
    required this.username,
    required this.fullName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withAlpha(200),
            colorScheme.tertiary.withAlpha(200),
          ],
        ),
      ),
      child: isScrolled
          ? const SizedBox.shrink()
          : SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  // Name
                  Text(
                    fullName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Username
                  Text(
                    username,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
    );
  }
}

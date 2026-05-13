import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTopBar extends ConsumerWidget {
  const ProfileTopBar({super.key, required bool isScrolled})
    : _isScrolled = isScrolled;

  final bool _isScrolled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    // final authCtrl = ref.read(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final name = authState.name;
    final email = authState.email;

    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: _isScrolled ? colorScheme.surface : Colors.transparent,
      elevation: _isScrolled ? 2 : 0,
      flexibleSpace: FlexibleSpaceBar(
        background: ProfileHeader(
          isScrolled: _isScrolled,
          username: email,
          fullName: name,
        ),
        title: _isScrolled
            ? const Text("Profile", style: TextStyle(fontSize: 18))
            : null,
        centerTitle: true,
      ),
    );
  }
}

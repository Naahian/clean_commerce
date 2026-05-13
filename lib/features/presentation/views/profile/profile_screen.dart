// profile_screen.dart
import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/views/profile/widgets/personal_info.dart';
import 'package:clean_commerce/features/presentation/widgets/appdarawer.dart';
import 'package:clean_commerce/features/presentation/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/widgets.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(authControllerProvider.notifier).getProfile(),
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 100 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      drawer: CustomDrawer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          ProfileTopBar(isScrolled: _isScrolled),

          // Stats Section
          SliverToBoxAdapter(
            child: const ProfileStats(
              totalOrders: 24,
              totalSpent: 1250.50,
              wishlistCount: 8,
            ),
          ),

          // Info Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                "Personal Information",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          PersonalInfo(),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

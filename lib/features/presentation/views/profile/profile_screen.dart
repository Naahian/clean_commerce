// profile_screen.dart
import 'package:clean_commerce/core/constansts.dart';
import 'package:clean_commerce/features/domain/entities/transaction_entity.dart';
import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/widgets/appdarawer.dart';
import 'package:clean_commerce/features/presentation/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

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
          ProfileTopBar(isScrolled: _isScrolled),
          SliverToBoxAdapter(
            child: const ProfileStats(
              totalOrders: 24,
              totalSpent: 1250.50,
              wishlistCount: 8,
            ),
          ),
          _buildTitle(theme, "Personal Info"),
          PersonalInfo(),
          _buildTitle(theme, "Most Recent Transaction"),
          _buildTransaction(),
          const SliverPadding(padding: EdgeInsetsGeometry.all(20)),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildTransaction() {
    TransactionEntity transaction = TransactionEntity(
      id: "TRX-D3M0T8AZSACT10Z",
      userId: "-1",
      type: TransactionType.payment.name,
      amount: 99.99,
      date: DateTime.now(),
    );
    return SliverToBoxAdapter(child: TileInfoItem(transaction: transaction));
  }

  SliverToBoxAdapter _buildTitle(ThemeData theme, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
        child: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

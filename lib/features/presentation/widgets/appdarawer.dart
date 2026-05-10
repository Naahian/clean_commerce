// custom_drawer.dart
import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);
    final theme = Theme.of(context);
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildDrawerHeader(authState.user?.email ?? 'Guest', theme),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.person_outline,
                      title: 'My Profile',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      onTap: () {},
                      hasBadge: true,
                      badgeCount: 3,
                    ),
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.favorite_border,
                      title: 'Wishlist',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.location_on_outlined,
                      title: 'Addresses',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      onTap: () {},
                    ),
                    const Divider(height: 32, thickness: 1),
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.support_agent,
                      title: 'Customer Support',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.share_outlined,
                      title: 'Share App',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.info_outline,
                      title: 'About',
                      onTap: () {},
                    ),
                    const Divider(height: 32, thickness: 1),
                    _buildDrawerItem(
                      theme: theme,
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () => _showLogoutDialog(context, authController),
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(String email, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary, theme.primaryColorDark],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 50,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('John Doe', style: TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 4),
          Text(email, style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Member since 2024',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    bool hasBadge = false,
    int badgeCount = 0,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: hasBadge
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Divider(thickness: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.verified_user, size: 16, color: Colors.grey[400]),
              Text(
                'Secure Shopping',
                style: TextStyle(color: Colors.grey[400]),
              ),
              Container(width: 1, height: 20, color: Colors.grey[300]),
              Icon(Icons.support, size: 16, color: Colors.grey[400]),
              Text('24/7 Support', style: TextStyle(color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 8),
          Text('Version 1.0.0', style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authController.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

import 'package:clean_commerce/features/presentation/viewmodels/app_settings_notifier.dart';
import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:clean_commerce/features/presentation/views/home/home_screen.dart';
import 'package:clean_commerce/features/presentation/views/profile/recentorders_screen.dart';
import 'package:clean_commerce/features/presentation/widgets/edit_dialog.dart';
import 'package:clean_commerce/features/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authControllerProvider.notifier);
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.watch(settingsProvider.notifier);
    final currency = settingsNotifier.getCurrencyChar();
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Divider(),
                  _buildDrawerItem(
                    theme: theme,
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    ),
                  ),
                  _buildDrawerItem(
                    theme: theme,
                    icon: Icons.monetization_on_outlined,
                    title: 'Currency: $currency',
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => EditDialog(
                        title: "Change Currency",
                        currentValue: currency,
                        onSave: (val) => settingsNotifier.setCurrency(val),
                        isSelectable: true,
                        options: ["BDT", "USD"],
                        inputType: TextInputType.text,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    theme: theme,
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    hasToggle: true,
                    toggled: settingsState.isDark,
                    onChanged: (val) => settingsNotifier.setDark(val),
                  ),

                  _buildDrawerItem(
                    theme: theme,
                    icon: Icons.shopping_bag_outlined,
                    title: 'Orders',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => RecentOrdersScreen()),
                    ),
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
                    onTap: () => controller.logout(),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Padding _buildDrawerHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Center(child: Logo()),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    required ThemeData theme,
    bool hasToggle = false,
    bool toggled = false,
    void Function(bool)? onChanged,
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
          color: isDestructive ? Colors.red : theme.textTheme.bodyLarge!.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: hasToggle ? Switch(value: toggled, onChanged: onChanged) : null,
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
          Text('Clean Commerce App', style: TextStyle(color: Colors.grey)),
          Text('Version 1.0.0', style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }
}

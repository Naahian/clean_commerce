import 'package:clean_commerce/features/presentation/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum NotificationType { info, success, warning }

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      'type': NotificationType.success.name,
      'title': 'Order Confirmed',
      'subtitle': "Your order #ORD-2024-001 has been confirmed",
      'time': '2 hours ago',
      'onTap': () {},
    },
    {
      'type': NotificationType.info.name,
      'title': 'Flash Sale Alert',
      'subtitle': "Flash Sale ongoing. Up to 50% off!",
      'time': '5 hours ago',
      'onTap': () {},
    },
    {
      'type': NotificationType.warning.name,
      'title': 'Payment Issue',
      'subtitle': "Your order payment has issues. Please update.",
      'time': '1 day ago',
      'onTap': () {},
    },
    {
      'type': NotificationType.success.name,
      'title': 'Order Shipped',
      'subtitle': "Your order #ORD-2024-002 has been shipped",
      'time': '2 days ago',
      'onTap': () {},
    },
    {
      'type': NotificationType.info.name,
      'title': 'New Arrivals',
      'subtitle': "Check out our new summer collection",
      'time': '3 days ago',
      'onTap': () {},
    },
    {
      'type': NotificationType.warning.name,
      'title': 'Low Stock Alert',
      'subtitle': "Wireless Headphones is running low in stock",
      'time': '5 days ago',
      'onTap': () {},
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final type = notification['type'] as String;

            IconData icon;
            Color color;

            switch (type) {
              case 'success':
                icon = Icons.check_circle_outline;
                color = Colors.green;
                break;
              case 'warning':
                icon = Icons.warning_amber_outlined;
                color = Colors.orange;
                break;
              default:
                icon = Icons.info_outline;
                color = Colors.blue;
            }

            return ListTile(
              onTap: notification['onTap'],
              leading: StatusIcon(
                icon: icon,
                color: color,
                size: 20,
                padding: 10,
              ),
              title: Text(
                notification['title'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                notification['subtitle'],
                style: theme.textTheme.bodySmall,
              ),
              trailing: Text(
                notification['time'],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
              isThreeLine: false,
              contentPadding: EdgeInsets.symmetric(vertical: 1.h),
            );
          },
        ),
      ),
    );
  }
}

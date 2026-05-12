import 'package:clean_commerce/features/presentation/views/home/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Size get preferredSize => Size(double.maxFinite, 8.h);

  @override
  Widget build(BuildContext context) {
    final bodyTextColor = Theme.of(context).textTheme.bodyLarge!.color;

    return AppBar(
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: bodyTextColor),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Welcome back,',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          Text('Shopper!', style: TextStyle(fontSize: 18.sp)),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: bodyTextColor),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => NotificationsScreen())),
        ),
        SizedBox(width: 3.w),
      ],
    );
  }
}

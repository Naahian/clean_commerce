import 'package:clean_commerce/features/presentation/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class Appbar extends ConsumerWidget implements PreferredSizeWidget {
  const Appbar({super.key});

  @override
  Size get preferredSize => Size(double.maxFinite, 8.h);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bodyTextColor = Theme.of(context).textTheme.bodyLarge!.color;
    final name = ref.watch(authControllerProvider).name;

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
          Text("$name!", style: TextStyle(fontSize: 18.sp)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DialogAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onSubmit;
  final Color? iconColor;
  final String cancelText;
  final String confirmText;

  const DialogAction({
    super.key,
    this.icon = Icons.info_outline,
    required this.title,
    this.subtitle,
    required this.onSubmit,
    this.iconColor,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: iconColor ?? colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            SizedBox(height: 1.h),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onSubmit();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: iconColor ?? colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

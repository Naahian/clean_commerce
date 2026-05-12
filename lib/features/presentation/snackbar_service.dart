import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  SnackbarService(this.messengerKey);

  void showSuccess(String message) {
    messengerKey.currentState?.showSnackBar(_buildSnackBar(false, message));
  }

  void showError(String message) {
    messengerKey.currentState?.showSnackBar(_buildSnackBar(true, message));
  }

  void showInfo(String message) {
    messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  SnackBar _buildSnackBar(bool isError, String message) {
    final color = isError ? Colors.red : Colors.green;

    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.shade900.withAlpha(110),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withAlpha(40), width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20.sp,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

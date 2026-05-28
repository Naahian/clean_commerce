import 'dart:ui';

import 'package:clean_commerce/core/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

final snackbarProvider = Provider<SnackbarService>(
  (ref) => getIt<SnackbarService>(),
);

class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  SnackbarService(this.messengerKey);

  void showSuccess(String message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => messengerKey.currentState?.showSnackBar(
        _buildSnackBar(type: SnackbarType.success, message: message),
      ),
    );
  }

  void showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => messengerKey.currentState?.showSnackBar(
        _buildSnackBar(type: SnackbarType.error, message: message),
      ),
    );
  }

  void showInfo(String message) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => messengerKey.currentState?.showSnackBar(
        _buildSnackBar(type: SnackbarType.info, message: message),
      ),
    );
  }

  SnackBar _buildSnackBar({
    required SnackbarType type,
    required String message,
  }) {
    Color color;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        color = Colors.green.shade600;
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        color = Colors.red.shade600;
        icon = Icons.error_outline;
        break;
      case SnackbarType.info:
        color = Colors.blue.shade600;
        icon = Icons.info_outline;
        break;
    }

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
              color: color.withAlpha(80),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withAlpha(100), width: 1),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20.sp),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
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

enum SnackbarType { success, error, info }

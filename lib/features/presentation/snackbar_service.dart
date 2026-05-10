import 'package:flutter/material.dart';

class SnackbarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  SnackbarService(this.messengerKey);

  void showSuccess(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.greenAccent.shade700,
        content: Text(message),
      ),
    );
  }

  void showError(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(backgroundColor: Colors.redAccent, content: Text(message)),
    );
  }

  void showInfo(String message) {
    messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }
}

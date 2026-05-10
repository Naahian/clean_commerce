import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.colorScheme.surface,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 80, color: theme.primaryColor),
              SizedBox(height: 30),
              SizedBox(width: 100, child: LinearProgressIndicator()),
              // SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: () => ManualTest().start(),
              //   child: Text("Test"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:clean_commerce/features/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(
          color: colorScheme.surface,
          gradient: LinearGradient(
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: [
              colorScheme.primary.withAlpha(80),
              Colors.transparent,
              colorScheme.tertiary.withAlpha(80),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(),
              SizedBox(height: 30),
              SizedBox(width: 100, child: LinearProgressIndicator()),
              SizedBox(height: 30),
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

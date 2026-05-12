import 'package:clean_commerce/features/presentation/views/auth/login_screen.dart';
import 'package:clean_commerce/features/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:clean_commerce/features/presentation/views/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Initial loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // Check current session
        final session = supabase.auth.currentSession;

        if (session != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

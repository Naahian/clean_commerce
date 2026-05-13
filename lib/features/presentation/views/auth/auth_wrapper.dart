import 'dart:async';

import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/features/presentation/snackbar_service.dart';
import 'package:clean_commerce/features/presentation/views/auth/login_screen.dart';
import 'package:clean_commerce/features/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:clean_commerce/features/presentation/views/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      key: ValueKey(supabase.auth.currentSession?.accessToken ?? 'no-session'),
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;

        if (session != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

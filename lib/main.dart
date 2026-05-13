import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/features/presentation/viewmodels/settings_notifier.dart';
import 'package:clean_commerce/features/presentation/views/auth/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize webview platform

  // Set to Vertical Orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await AppDependency.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode mode = ref.watch(settingsProvider).isDark
        ? ThemeMode.dark
        : ThemeMode.light;

    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          scaffoldMessengerKey: getIt<GlobalKey<ScaffoldMessengerState>>(),
          title: 'Clean Commerce',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: AuthWrapper(),
        );
      },
    );
  }
}

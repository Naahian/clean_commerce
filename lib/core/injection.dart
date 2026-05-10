import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/data/services/comment_service.dart';
import 'package:clean_commerce/features/data/services/order_service.dart';
import 'package:clean_commerce/features/data/services/product_service.dart';
import 'package:clean_commerce/features/data/services/transaction_service.dart';
import 'package:clean_commerce/features/domain/repositories/auth_repo_imp.dart';
import 'package:clean_commerce/features/domain/repositories/comment_repo_imp.dart';
import 'package:clean_commerce/features/domain/repositories/order_repo_imp.dart';
import 'package:clean_commerce/features/domain/repositories/product_repo_imp.dart';
import 'package:clean_commerce/features/domain/repositories/transaction_repo_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:clean_commerce/core/services/localstorage_service.dart';
import 'package:clean_commerce/features/data/services/auth_service.dart';
import 'package:clean_commerce/core/services/securestorage_service.dart';
import 'package:clean_commerce/features/presentation/snackbar_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

class AppDependency {
  static Future<void> init() async {
    /// CONSTANTS

    getIt.registerLazySingleton<GlobalKey<ScaffoldMessengerState>>(
      () => GlobalKey<ScaffoldMessengerState>(),
    );

    /// SERVICES

    // Supabase
    await dotenv.load();
    await _initSupabase();

    // LocalStorage Service
    getIt.registerLazySingleton<LocalStorageService>(
      () => LocalStorageService(),
    );
    getIt<LocalStorageService>().init();

    // Remote Services
    getIt.registerLazySingleton<AuthService>(() => AuthService(getIt()));
    getIt.registerLazySingleton<ProductService>(() => ProductService(getIt()));
    getIt.registerLazySingleton<OrderService>(() => OrderService(getIt()));
    getIt.registerLazySingleton<TransactionService>(
      () => TransactionService(getIt()),
    );
    getIt.registerLazySingleton<CommentService>(() => CommentService(getIt()));

    // SecureStorage Service
    getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(FlutterSecureStorage()),
    );

    // Snackbar Service
    getIt.registerLazySingleton<SnackbarService>(
      () => SnackbarService(getIt()),
    );
    if (kDebugMode) print("[APP INIT] Services Initialized.");

    /// REPOSITORIES

    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImp(
        remote: getIt<AuthService>(),
        local: getIt<LocalStorageService>(),
      ),
    );

    getIt.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImp(
        remote: getIt<ProductService>(),
        local: getIt<LocalStorageService>(),
      ),
    );

    getIt.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImp(remote: getIt<OrderService>()),
    );
    getIt.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImp(remote: getIt<TransactionService>()),
    );

    getIt.registerLazySingleton<CommentRepository>(
      () => CommentRepositoryImp(remote: getIt<CommentService>()),
    );
    if (kDebugMode) print("[APP INIT] Repositories Initialized.");

    /// CONTROLLERS

    if (kDebugMode) print("[APP INIT] Controllers Initialized.");
  }

  static Future<void> _initSupabase() async {
    await Supabase.initialize(
      url: dotenv.get("DATABASE_URL"),
      anonKey: dotenv.get("ANON_KEY"),
    );
    getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

    if (kDebugMode) print("[APP INIT] Supabase Initialized.");
  }
}

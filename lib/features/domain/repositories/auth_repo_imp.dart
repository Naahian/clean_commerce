import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/core/services/localstorage_service.dart';
import 'package:clean_commerce/features/data/models/auth_models.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/data/services/auth_service.dart';
import 'package:clean_commerce/features/domain/entities/profile_entity.dart';
import 'package:clean_commerce/features/domain/entities/result_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => getIt<AuthRepository>(),
);

class AuthRepositoryImp implements AuthRepository {
  final AuthService remote;
  final LocalStorageService local;

  AuthRepositoryImp({required this.remote, required this.local});

  @override
  Future<Result<dynamic>> login(String email, String password) async {
    try {
      final result = await remote.login(
        LoginModel(email: email, password: password),
      );
      return Result(
        success: true,
        message: "Successfully Logged In.",
        data: result,
      );
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<dynamic>> signUp(
    String email,
    String password,
    String displayName,
    String phone,
  ) async {
    try {
      final result = await remote.createUser(
        CreateUserModel(
          email: email,
          password: password,
          displayName: displayName,
          phone: phone,
        ),
      );

      return Result(
        success: true,
        message: "Account created for ${result.email}",
      );
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<dynamic>> deleteAccount() async {
    try {
      await remote.deleteMyAccount();

      await local.clearAll();

      return Result(success: true, message: "Account deleted successfully.");
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<ProfileEntity>> getUserInfo() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) throw Exception("Not authenticated!");

      final user = await remote.getUser(id: currentUser.id);

      if (user == null) {
        return Result(success: false, message: "User not found.");
      }

      return Result<ProfileEntity>(
        success: true,
        data: ProfileEntity.fromProfileModel(user),
      );
    } catch (e) {
      return Result<ProfileEntity>(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<dynamic>> logout() async {
    try {
      final client = Supabase.instance.client;
      await client.auth.signOut();
      return Result(success: true, message: "Logged Out.");
    } catch (e) {
      return Result(success: false, message: "Error Logging Out.");
    }
  }

  @override
  Future<Result<dynamic>> googleSignIn() async {
    try {
      await remote.googleSignIn();

      return Result(success: true, message: "Successfully Logged In.");
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }

  @override
  Future<Result<dynamic>> update(String? phone, String? address) async {
    try {
      final result = await remote.updateAuthUser(
        phone: phone,
        address: address,
      );

      return Result(
        success: true,
        message: "Update User Info.",
        data: ProfileEntity.fromProfileModel(result),
      );
    } catch (e) {
      return Result(success: false, message: e.toString());
    }
  }
}

import 'package:clean_commerce/core/services/localstorage_service.dart';
import 'package:clean_commerce/features/data/models/auth_models.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/data/services/auth_service.dart';
import 'package:clean_commerce/features/domain/entity/result_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  ) async {
    try {
      final result = await remote.createUser(
        CreateUserModel(
          email: email,
          password: password,
          displayName: displayName,
        ),
      );

      return Result(
        success: true,
        message: "Account created successfully.",
        data: result,
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
  Future<Result<User>> getUserInfo() async {
    try {
      final user = await remote.getAuthUser();

      if (user == null) {
        return Result(success: false, message: "User not found.");
      }

      return Result<User>(success: true, data: user);
    } catch (e) {
      return Result<User>(success: false, message: e.toString());
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
}

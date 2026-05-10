import 'package:clean_commerce/features/data/models/auth_models.dart';
import 'package:clean_commerce/features/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client;
  AuthService(this._client);

  /// AUTH

  Future<User> createUser(CreateUserModel data) async {
    try {
      final response = await _client.auth.signUp(
        email: data.email,
        password: data.password,
        data: {"display_name": data.displayName},
      );

      final user = response.user;
      if (user == null) {
        throw Exception("Login Failed. User: null.");
      } else {
        return user;
      }
    } on AuthException catch (e) {
      throw Exception(" ${e.message}");
    } catch (e) {
      throw Exception("Unknown Error while creating User.");
    }
  }

  Future<User> login(LoginModel data) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: data.email,
        password: data.password,
      );
      final user = response.user;
      if (user == null) {
        throw Exception("Login Failed. User: null.");
      } else {
        return user;
      }
    } on AuthException catch (e) {
      throw Exception(" ${e.message}");
    } catch (e) {
      throw Exception("Unknown Error while login.");
    }
  }

  Future<User?> getAuthUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) throw Exception("Failed to Get UserInfo. Found Null.");
      return user;
    } on AuthException catch (e) {
      throw Exception(" ${e.message}");
    } catch (e) {
      throw Exception("Unknown Error while getting Auth User.");
    }
  }

  Future<User> updateAuthUser({
    String? email,
    String? password,
    String? username,
    String? fullName,
    String? avatarUrl,
    String? bio,
  }) async {
    try {
      // 1. Update Auth user (email/password/metadata)
      final authResponse = await _client.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
          data: {"username": ?username, "full_name": ?fullName},
        ),
      );

      final user = authResponse.user;

      if (user == null) {
        throw Exception("Update Failed. Auth user is null.");
      }

      // 2. Build profile update payload (only non-null fields)
      final profileData = <String, dynamic>{
        "username": ?username,
        "full_name": ?fullName,
        "avatar_url": ?avatarUrl,
        "bio": ?bio,
        "updated_at": DateTime.now().toIso8601String(),
      };

      // 3. Update profile table
      await _client.from('profiles').update(profileData).eq('id', user.id);

      return user;
    } on AuthException catch (e) {
      throw Exception(" ${e.message}");
    } catch (e) {
      throw Exception("Unknown Error while updating user & profile.");
    }
  }

  Future<void> deleteMyAccount() async {
    try {
      final session = _client.auth.currentSession;

      if (session == null) throw Exception("Not authenticated");

      final response = await _client.functions.invoke(
        'delete-account',
        headers: {'Authorization': 'Bearer ${session.accessToken}'},
      );

      await _client.auth.signOut();
      if (response.status != 200) {
        throw Exception("Failed to delete account");
      }
    } catch (e) {
      throw Exception("Error deleting account ");
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception("Failed to Logout");
    }
  }

  // Get User Profile
  Future<ProfileModel?> getUser({required String id}) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return ProfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception(" ${e.message}");
    } catch (e) {
      throw Exception("Unknow Error while getting User.");
    }
  }

  /// HELPER FUNCTIONS
}

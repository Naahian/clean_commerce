import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/domain/entities/profile_entity.dart';
import 'package:clean_commerce/features/domain/repositories/auth_repo_imp.dart';
import 'package:clean_commerce/features/presentation/snackbar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// STATE
// ----------------------------------------------------
class AuthState {
  final bool isLoading;
  final User? user;
  final ProfileEntity? profile;

  const AuthState({this.isLoading = false, this.user, this.profile});

  AuthState copyWith({bool? isLoading, User? user, ProfileEntity? profile}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }

  bool get isAuthenticated => user != null;
  String get email => user?.email ?? "none";
  String get name =>
      profile?.fullName ?? user?.userMetadata?['display_name'] ?? "Shopper";
}

// PROVIDERS
// ----------------------------------------------------

// TODO: might need it
// final sessionProvider = StreamProvider(
//   (ref) =>
//       Supabase.instance.client.auth.onAuthStateChange.map((e) => e.session),
// );

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

// CONTROLLER
// ----------------------------------------------------
class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repo;
  late final SnackbarService _snackbar;
  final SupabaseClient _supabase = Supabase.instance.client;

  // LIFECYCLE
  // ----------------------------------------------------
  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    _snackbar = ref.read(snackbarProvider);

    // _listenToAuthChanges();

    return AuthState(
      user: _supabase.auth.currentUser,
      profile: _initUserInfo(),
    );
  }

  // void _listenToAuthChanges() {
  //   ref.listen(sessionProvider, (prev, next) {
  //     final session = next.value;
  //     if (session?.user == null) {
  //       state = const AuthState();
  //     }
  //   });
  // }

  ProfileEntity? _initUserInfo() {
    _repo.getUserInfo().then((result) {
      if (result.success && state.user != null) {
        state = state.copyWith(profile: result.data);
      }
    });
    return null;
  }

  // PROFILE
  // ----------------------------------------------------
  Future<void> getProfile() async {
    state = state.copyWith(isLoading: true, user: _supabase.auth.currentUser);

    if (state.user == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final result = await _repo.getUserInfo();

    if (result.success) {
      state = state.copyWith(profile: result.data, isLoading: false);
    } else {
      state = state.copyWith(isLoading: false);
      _snackbar.showError("Failed to get profile");
    }
  }

  // AUTHENTICATION
  // ----------------------------------------------------
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    final result = await _repo.login(email, password);

    if (result.success) {
      state = state.copyWith(isLoading: false, user: result.data);
      _snackbar.showSuccess(result.message ?? "Login successful");
    } else {
      state = state.copyWith(isLoading: false);
      _snackbar.showError(result.message ?? "Login failed");
    }
  }

  Future<void> googleSignIn() async {
    state = state.copyWith(isLoading: true);
    final result = await _repo.googleSignIn();

    if (result.success) {
      _snackbar.showSuccess(result.message ?? "Google sign-in successful");
      state = state.copyWith(isLoading: false);
    } else {
      _snackbar.showError(result.message ?? "Google sign-in failed");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true);
    final result = await _repo.signUp(email, password, displayName, phone);

    if (result.success) {
      state = state.copyWith(isLoading: false, user: result.data);
      _snackbar.showSuccess(result.message ?? "Account created successfully");
    } else {
      state = state.copyWith(isLoading: false);
      _snackbar.showError(result.message ?? "Sign up failed");
    }
  }

  Future<void> logout() async {
    final result = await _repo.logout();

    if (result.success) {
      state = const AuthState();
      _snackbar.showSuccess(result.message ?? "Logged out successfully");
    } else {
      _snackbar.showError(result.message ?? "Logout failed");
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    final result = await _repo.deleteAccount();

    if (result.success) {
      state = const AuthState();
      _snackbar.showSuccess(result.message ?? "Account deleted");
    } else {
      state = state.copyWith(isLoading: false);
      _snackbar.showError(result.message ?? "Failed to delete account");
    }
  }

  // PROFILE UPDATES
  // ----------------------------------------------------
  Future<void> updateAddress(String address) async {
    await _updateProfile(phone: null, address: address);
  }

  Future<void> updatePhone(String phone) async {
    await _updateProfile(phone: phone, address: null);
  }

  Future<void> _updateProfile({String? phone, String? address}) async {
    state = state.copyWith(isLoading: true);
    final result = await _repo.update(phone, address);

    if (result.success) {
      await getProfile();
      _snackbar.showSuccess(result.message ?? "Profile updated");
    } else {
      state = state.copyWith(isLoading: false);
      _snackbar.showError(result.message ?? "Update failed");
    }
  }

  // VALIDATORS
  // ----------------------------------------------------
  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    const emailRegex = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    if (!RegExp(emailRegex).hasMatch(value.trim())) {
      return "Enter a valid email";
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return "Password must contain a letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain a number";
    }

    return null;
  }
}

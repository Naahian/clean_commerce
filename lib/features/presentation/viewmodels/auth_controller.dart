import 'package:clean_commerce/core/injection.dart';
import 'package:clean_commerce/features/data/repositories.dart';
import 'package:clean_commerce/features/presentation/snackbar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final dynamic user;
  final String? error;

  const AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, dynamic user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => getIt<AuthRepository>(),
);
final snackbarProvider = Provider<SnackbarService>(
  (ref) => getIt<SnackbarService>(),
);

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repo;
  late final SnackbarService _snackbar;
  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    _snackbar = ref.read(snackbarProvider);
    return const AuthState();
  }

  // LOGIN

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repo.login(email, password);

    if (result.success) {
      state = state.copyWith(isLoading: false, user: result.data);
      _snackbar.showSuccess(result.message ?? "Success");
    } else {
      state = state.copyWith(isLoading: false, error: result.message);
      _snackbar.showError(result.message ?? "Failed");
    }
  }

  // SIGNUP

  Future<void> signUp(String email, String password, String displayName) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repo.signUp(email, password, displayName);

    if (result.success) {
      state = state.copyWith(isLoading: false, user: result.data);
      _snackbar.showSuccess(result.message ?? "Success");
    } else {
      state = state.copyWith(isLoading: false, error: result.message);
      _snackbar.showError(result.message ?? "Failed");
    }
  }

  // LOGOUT / DELETE

  Future<void> logout() async {
    final result = await _repo.logout();
    if (result.success) {
      _snackbar.showSuccess(result.message ?? "success");
    } else {
      _snackbar.showSuccess(result.message ?? "failed");
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);

    final result = await _repo.deleteAccount();

    if (result.success) {
      state = const AuthState();
      _snackbar.showSuccess(result.message ?? "Success");
    } else {
      state = state.copyWith(isLoading: false, error: result.message);
      _snackbar.showError(result.message ?? "Failed");
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!emailRegex.hasMatch(value.trim())) {
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

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class LoginModel {
  final String email;
  final String password;

  const LoginModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}

class CreateUserModel {
  final String email;
  final String password;
  final String? displayName;
  final String? phone;

  const CreateUserModel({
    required this.email,
    required this.password,
    this.displayName,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "phone": phone,
      "data": {"full_name": displayName},
    };
  }
}

class LoginResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? userId;
  final String? email;

  const LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.email,
  });

  factory LoginResponse.fromSupabase(dynamic response) {
    final session = response.session;
    final user = response.user;

    return LoginResponse(
      accessToken: session?.accessToken,
      refreshToken: session?.refreshToken,
      userId: user?.id,
      email: user?.email,
    );
  }

  bool get isAuthenticated => accessToken != null;
}

class CreateUserResponse {
  final String? userId;
  final String? email;
  final String? accessToken;
  final String? refreshToken;
  final bool emailConfirmed;

  const CreateUserResponse({
    this.userId,
    this.email,
    this.accessToken,
    this.refreshToken,
    required this.emailConfirmed,
  });

  factory CreateUserResponse.fromSupabase(dynamic response) {
    final user = response.user;
    final session = response.session;

    return CreateUserResponse(
      userId: user?.id,
      email: user?.email,
      accessToken: session?.accessToken,
      refreshToken: session?.refreshToken,
      emailConfirmed: user?.emailConfirmedAt != null,
    );
  }

  bool get hasSession => accessToken != null;
}

class AuthUserModel {
  final String id;
  final String? email;
  final bool emailConfirmed;
  final DateTime? createdAt;
  final DateTime? lastSignInAt;

  const AuthUserModel({
    required this.id,
    this.email,
    required this.emailConfirmed,
    this.createdAt,
    this.lastSignInAt,
  });

  factory AuthUserModel.fromSupabase(dynamic user) {
    return AuthUserModel(
      id: user.id,
      email: user.email,
      emailConfirmed: user.emailConfirmedAt != null,
      createdAt: user.createdAt != null
          ? DateTime.tryParse(user.createdAt)
          : null,
      lastSignInAt: user.lastSignInAt != null
          ? DateTime.tryParse(user.lastSignInAt!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "email_confirmed": emailConfirmed,
      "created_at": createdAt?.toIso8601String(),
      "last_sign_in_at": lastSignInAt?.toIso8601String(),
    };
  }
}

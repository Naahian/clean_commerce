class ProfileModel {
  final String id;
  final String? username;
  final String? fullName;
  final String? avatarUrl;
  final String? bio;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.bio,
    this.role = 'user',
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      role: json['role'] ?? 'user',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "full_name": fullName,
      "avatar_url": avatarUrl,
      "bio": bio,
      "role": role,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? username,
    String? fullName,
    String? avatarUrl,
    String? bio,
    String? role,
  }) {
    return ProfileModel(
      id: id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

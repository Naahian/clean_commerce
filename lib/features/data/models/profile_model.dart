class ProfileModel {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? address;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "avatar_url": avatarUrl,
      "address": address,
      "phone": phone,
      "created_at": createdAt?.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? fullName,
    String? avatarUrl,
    String? address,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return '''
ProfileModel(
  id: $id,
  fullName: $fullName,
  avatarUrl: $avatarUrl,
  address: $address,
  phone: $phone,
  createdAt: $createdAt,
  updatedAt: $updatedAt
)
''';
  }
}

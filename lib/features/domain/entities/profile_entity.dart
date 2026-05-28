import 'package:clean_commerce/features/data/models/profile_model.dart';

class ProfileEntity {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? address;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileEntity.fromProfileModel(ProfileModel model) {
    return ProfileEntity(
      id: model.id,
      fullName: model.fullName,
      avatarUrl: model.avatarUrl,
      address: model.address,
      phone: model.phone,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  @override
  String toString() {
    return '''
ProfileEntity(
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

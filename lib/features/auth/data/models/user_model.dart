import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.role,
    super.status,
    super.provinceId,
    super.provinceName,
    super.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['username']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString(),
      status: json['status']?.toString(),
      provinceId: json['province_id']?.toString(),
      provinceName: json['province_name']?.toString(),
      avatarUrl: json['avatar_url']?.toString() ?? json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': name,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'province_id': provinceId,
      'province_name': provinceName,
      'avatar_url': avatarUrl,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
      status: entity.status,
      provinceId: entity.provinceId,
      provinceName: entity.provinceName,
      avatarUrl: entity.avatarUrl,
    );
  }
}

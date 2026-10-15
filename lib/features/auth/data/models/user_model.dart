import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? status;
  final String? provinceId;
  final String? provinceName;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.status,
    this.provinceId,
    this.provinceName,
    this.avatarUrl,
  });

  String get displayName =>
      name.isNotEmpty ? name : (email.contains('@') ? email.split('@').first : email);

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

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        status,
        provinceId,
        provinceName,
        avatarUrl,
      ];
}

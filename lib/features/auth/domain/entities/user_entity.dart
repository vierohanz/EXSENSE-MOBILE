import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? status;
  final String? provinceId;
  final String? provinceName;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.status,
    this.provinceId,
    this.provinceName,
    this.avatarUrl,
  });

  String get displayName => name.isNotEmpty ? name : (email.contains('@') ? email.split('@').first : email);

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

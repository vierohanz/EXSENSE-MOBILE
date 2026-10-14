class UserSchema {
  UserSchema._();

  // JSON / DB Keys
  static const String keyId = 'id';
  static const String keyName = 'name';
  static const String keyEmail = 'email';
  static const String keyPassword = 'password';
  static const String keyRole = 'role';
  static const String keyAvatarUrl = 'avatar_url';
  static const String keyToken = 'token';
  static const String keyRefreshToken = 'refresh_token';

  // Role Constants
  static const String roleAdmin = 'Super Admin';
  static const String roleManager = 'Manager';
  static const String roleStaff = 'Staff Member';
  static const String roleDriver = 'Driver';
}

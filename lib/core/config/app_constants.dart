import 'flavor.dart';

class AppConstants {
  AppConstants._();

  static String get appName => FlavorConfig.instance.appName;
  static const String appVersion = '1.0.0';

  static const String tokenKey = 'AUTH_TOKEN';
  static const String userKey = 'USER_DATA';
  static const String themeKey = 'APP_THEME_MODE';
  static const String isFirstInstallKey = 'IS_FIRST_INSTALL';

  static String get defaultBaseUrl => FlavorConfig.instance.baseUrl;
  static String get appEnv => FlavorConfig.instance.flavor.name;
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
}

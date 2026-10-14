import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Marga Mulya Mobile';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String tokenKey = 'AUTH_TOKEN';
  static const String userKey = 'USER_DATA';
  static const String themeKey = 'APP_THEME_MODE';
  static const String isFirstInstallKey = 'IS_FIRST_INSTALL';

  // API Config
  static String get defaultBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:5000';
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';
  static const int connectTimeout = 30000; // 30s
  static const int receiveTimeout = 30000; // 30s

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
}

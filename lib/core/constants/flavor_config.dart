enum AppFlavorType {
  development,
  staging,
  production,
}

class FlavorConfig {
  final AppFlavorType flavor;
  final String appName;
  final String baseUrl;

  static late final FlavorConfig instance;

  FlavorConfig._({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
  });

  static void initialize({
    required AppFlavorType flavor,
    required String appName,
    required String baseUrl,
  }) {
    instance = FlavorConfig._(
      flavor: flavor,
      appName: appName,
      baseUrl: baseUrl,
    );
  }

  static bool get isDevelopment => instance.flavor == AppFlavorType.development;
  static bool get isStaging => instance.flavor == AppFlavorType.staging;
  static bool get isProduction => instance.flavor == AppFlavorType.production;
}

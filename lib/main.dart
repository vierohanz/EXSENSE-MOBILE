import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/config/flavor.dart';
import 'core/utils/storage_service.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final activeFlavor =
      appFlavor ?? const String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  switch (activeFlavor) {
    case 'prod':
    case 'production':
      FlavorConfig.initialize(
        flavor: AppFlavorType.production,
        appName: 'Exsense',
        baseUrl: 'https://api.exsense.com',
      );
      break;
    case 'staging':
      FlavorConfig.initialize(
        flavor: AppFlavorType.staging,
        appName: 'Exsense Staging',
        baseUrl: 'https://staging-api.exsense.com',
      );
      break;
    default:
      FlavorConfig.initialize(
        flavor: AppFlavorType.development,
        appName: 'Exsense Dev',
        baseUrl: 'http://10.0.2.2:5000',
      );
      break;
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.i('Initializing global application services...');
  await Hive.initFlutter();
  final storageService = StorageService();
  await storageService.init();
  Get.put<StorageService>(storageService, permanent: true);
  AppLogger.i('Services initialized successfully with Hive & GetX.');

  runApp(const ExsenseApp());
}

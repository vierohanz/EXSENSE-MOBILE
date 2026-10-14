import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/services/storage_service.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  AppLogger.i('Initializing global application services...');
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  final storageService = StorageService();
  await storageService.init();
  Get.put<StorageService>(storageService, permanent: true);
  AppLogger.i('Services initialized successfully with Hive & GetX.');

  runApp(const MargaMulyaApp());
}

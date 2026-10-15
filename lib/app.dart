import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/config/app_constants.dart';
import 'core/network/api_client.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        storageService: Get.find<StorageService>(),
      ),
      fenix: true,
    );
  }
}

class ExsenseApp extends StatelessWidget {
  const ExsenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      navigatorKey: rootNavigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
    );
  }
}

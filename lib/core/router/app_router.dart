import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import 'app_routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(debugLabel: 'rootScaffoldMessenger');

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      transition: Transition.cupertino,
    ),
  ];
}

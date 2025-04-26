import 'package:get/get.dart';
import 'package:personal_ai_assistant/home_page.dart';
import 'package:personal_ai_assistant/initialization.dart/views/splashScreen.dart';
import 'package:personal_ai_assistant/views/auth/login_screen.dart';
import 'package:personal_ai_assistant/views/auth/signup_screen.dart';

import 'app_bindings.dart';

abstract class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const HOME = '/home';
  // Add other routes as needed
}

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () =>  LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignUpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
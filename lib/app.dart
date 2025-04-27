import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/initialization.dart/views/global_error_screen.dart';
import 'package:personal_ai_assistant/utilities/theme.dart';
import 'package:personal_ai_assistant/views/home/speech_to_text_page.dart';

import 'controller/theme_controller.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/home/daily_planner.dart';
import 'views/home/dashboard_view.dart';
import 'views/home/task_view.dart';

class ReadyApp extends StatelessWidget {
  const ReadyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignUpScreen()),
        GetPage(name: '/home', page: () => DashboardView()), 
        GetPage(name: '/taskView', page: () => TaskCreationPage()), 
        GetPage(name: '/dailyplanner', page: () => DailyPlannerScreen()),
      ],
      theme: lightTheme,
      darkTheme: darkTheme, // Add dark theme
      themeMode: ThemeMode.system, // This makes the app follow system theme
      title: 'AI Assistant',
      home: DashboardView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class ErrorApp extends StatelessWidget {
  const ErrorApp({
    super.key,
    this.error,
    this.stackTrace,
    required this.onRefresh,
  });

  final Object? error;
  final VoidCallback onRefresh;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Obx((){
      final themeController = Get.find<ThemeController>();
     return GetMaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.themeMode.value,
        title: 'AI Assistant',
        home: ErrorPage(
          error: error,
          stackTrace: stackTrace,
          onRefresh: onRefresh,
        ),
        debugShowCheckedModeBanner: false,
      );
  });
  }
}
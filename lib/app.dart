import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/initialization.dart/views/global_error_screen.dart';
import 'package:personal_ai_assistant/utilities/theme.dart';
import 'controller/theme_controller.dart';
import 'routes/app_pages.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/home/daily_planner.dart';
import 'views/home/dashboard_view.dart';
import 'views/home/task_view.dart';
import 'services/auth_storage_service.dart';

class ReadyApp extends StatefulWidget {
  const ReadyApp({super.key});

  @override
  State<ReadyApp> createState() => _ReadyAppState();
}

class _ReadyAppState extends State<ReadyApp> {
  final ThemeController _themeController = Get.put(ThemeController());
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final isLoggedIn = await AuthStorageService.isLoggedIn();
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        getPages:pages,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeController.themeMode.value,
        title: 'AI Assistant',
        home: _isLoading
            ? const Scaffold(body: Center(child: CircularProgressIndicator()))
            : _isLoggedIn
                ? DashboardView()
                : LoginScreen(),
        debugShowCheckedModeBanner: false,
      );
    });
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
    return Obx(() {
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
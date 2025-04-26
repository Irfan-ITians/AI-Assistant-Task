import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/initialization.dart/views/global_error_screen.dart';
import 'package:personal_ai_assistant/home_page.dart';
import 'package:personal_ai_assistant/light_theme.dart';

class ReadyApp extends StatelessWidget {
  const ReadyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: lightTheme,
      title: 'AI Assistant',
      home: const HomePage(),
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
    return GetMaterialApp(
      theme: lightTheme,
      title: 'AI Assistant',
      home: ErrorPage(
        error: error,
        stackTrace: stackTrace,
        onRefresh: onRefresh,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
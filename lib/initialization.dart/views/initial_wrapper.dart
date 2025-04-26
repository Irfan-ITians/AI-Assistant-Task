
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/initialization.dart/controllers/init_controller.dart';
import 'package:personal_ai_assistant/app.dart';

import 'splashScreen.dart';

class InitialWrapper extends StatelessWidget {
  const InitialWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InitializationController>(
      init: InitializationController(),
      builder: (controller) {
        switch (controller.appState) {
          case InitialAppState.loading:
            return const SplashScreen();
          case InitialAppState.initialized:
            return const ReadyApp();
          case InitialAppState.error:
            return ErrorApp(
              error: controller.error,
              stackTrace: controller.stackTrace,
              onRefresh: controller.initializeApp,
            );
        }
      },
    );
  }
}

import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/firebase_options.dart';

enum InitialAppState { loading, initialized, error }

class InitializationController extends GetxController {
  static InitializationController get find => Get.find();

  Object? error;
  StackTrace? stackTrace;
  InitialAppState appState = InitialAppState.loading;

  void updateAppState(InitialAppState state, [Object? e, StackTrace? s]) {
    error = e;
    stackTrace = s;
    appState = state;
    update();
  }

  @override
  void onReady() => initializeApp();

  Future<void> initializeApp() async {
    try {
      updateAppState(InitialAppState.loading);
      
      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Simulate other initialization tasks
      await Future.delayed(const Duration(seconds: 2));

      updateAppState(InitialAppState.initialized);
    } catch (e, s) {
      log("Initialization Error", error: e, stackTrace: s);
      updateAppState(InitialAppState.error, e, s);
      rethrow;
    }
  }
}
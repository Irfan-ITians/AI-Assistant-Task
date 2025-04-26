import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/controller/auth_controller.dart';
import 'package:personal_ai_assistant/firebase_options.dart';
import 'package:personal_ai_assistant/models/task/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import '../../controller/task_controller.dart';

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
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      Get.lazyPut(() => AuthController());
      await Hive.initFlutter();

  //await Hive.deleteBoxFromDisk('tasksBox'); // <<< ADD THIS TO CLEAN OLD BOX!!

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskAdapter());
  }

  await Hive.openBox<Task>('tasksBox');

  Get.lazyPut(() => TaskController(), fenix: true);
 
      updateAppState(InitialAppState.initialized);
    } catch (e, s) {
      log("Initialization Error", error: e, stackTrace: s);
      updateAppState(InitialAppState.error, e, s);
    rethrow;
    }
  }
}
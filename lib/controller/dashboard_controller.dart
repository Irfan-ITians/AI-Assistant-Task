
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'task_controller.dart';

class DashboardController extends GetxController {
  final TaskController taskController = Get.find();

  var mood = '😊'.obs;
  final availableMoods = ['😊', '😐', '😞', '😴', '🤯'];

  String get taskSummary {
    final todayTasks = taskController.tasks.where((t) => 
      taskController.isSameDay(t.dueDate, DateTime.now()));
    final completed = todayTasks.where((t) => t.isCompleted).length;
    return '$completed/${todayTasks.length} tasks completed today';
  }

  String get productivityTip {
    if (mood.value == '😞') return "Take it easy today. Focus on self-care.";
    if (mood.value == '🤯') return "Prioritize! Tackle one thing at a time.";
    return "You've got this! Maintain your momentum.";
  }

  void updateMood(String newMood) {
    mood.value = newMood;
  }

  String formattedDate() {
    return DateFormat('EEEE, MMMM d').format(DateTime.now());
  }
}

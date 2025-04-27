

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/task/task_model.dart';

class TaskController extends GetxController {
  late Box<Task> taskBox;
  final Uuid uuid = const Uuid();

  var tasks = <Task>[].obs;
  var filteredTasks = <Task>[].obs;
  var isInitialized = false.obs;
  var selectedDate = DateTime.now().obs;

  TextEditingController taskInputController = TextEditingController();
  
    void updateFromSpeech(String text) {
    taskInputController.text = text;
  }

  @override
  void onInit() {
    super.onInit();
    _initHive();
  }
    @override
  void onClose() {
    taskInputController.dispose();
    super.onClose();
  }

  Future<void> _initHive() async {
    if (!Hive.isBoxOpen('tasksBox')) {
      taskBox = await Hive.openBox<Task>('tasksBox');
    } else {
      taskBox = Hive.box<Task>('tasksBox');
    }
    await loadTasks();
    isInitialized.value = true;
  }



 
 

  Future<void> loadTasks() async {
    tasks.assignAll(taskBox.values.toList());
    filterTasks();
  }

  // In TaskController class
Future<void> editTask(String id, Task updatedTask) async {
  try {
    await taskBox.put(id, updatedTask);
    final taskIndex = tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      tasks[taskIndex] = updatedTask;
      filterTasks();
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to update task: $e');
  }
}

  Future<void> deleteTask(String id) async {
    try {
      await taskBox.delete(id);
      tasks.removeWhere((task) => task.id == id);
      filterTasks();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e');
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    try {
      final taskIndex = tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        final task = tasks[taskIndex];
        final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

        await taskBox.put(id, updatedTask);
        tasks[taskIndex] = updatedTask;
        filterTasks();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle completion: $e');
    }
  }

  void filterTasks() {
    filteredTasks.assignAll(tasks.where((task) {
      return isSameDay(task.dueDate, selectedDate.value);
    }).toList());
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
    filterTasks();
  }

  Future<bool> addTaskFromInput(String input) async {
    try {
      final parsedTask = _parseNaturalLanguage(input);
      
      final newTask = Task(
        id: uuid.v4(),
        title: parsedTask['title']!,
        dueDate: parsedTask['dueDate']!,
        category: parsedTask['category']!,
        priority: parsedTask['priority']!,
        notes: parsedTask['notes'],
        location: parsedTask['location'],
      );

      await taskBox.put(newTask.id, newTask);
      tasks.add(newTask);
      filterTasks();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
      return false;
    }
  }

  Map<String, dynamic> _parseNaturalLanguage(String input) {
    String title = input;
    DateTime dueDate = DateTime.now();
    String category = 'General';
    int priority = 3;
    String? notes;
    String? location;

    // Parse date/time
    final now = DateTime.now();
    if (input.toLowerCase().contains("tomorrow")) {
      dueDate = now.add(const Duration(days: 1));
      title = title.replaceAll(RegExp(r'\btomorrow\b', caseSensitive: false), '').trim();
    } else if (input.toLowerCase().contains("next week")) {
      dueDate = now.add(const Duration(days: 7));
      title = title.replaceAll(RegExp(r'\bnext week\b', caseSensitive: false), '').trim();
    } else if (RegExp(r'\b(monday|tuesday|wednesday|thursday|friday|saturday|sunday)\b').hasMatch(input.toLowerCase())) {
      final dayMatch = RegExp(r'\b(monday|tuesday|wednesday|thursday|friday|saturday|sunday)\b').firstMatch(input.toLowerCase());
      final day = dayMatch?.group(0);
      final daysToAdd = _daysUntilNext(day!);
      dueDate = now.add(Duration(days: daysToAdd));
      title = title.replaceAll(RegExp(r'\b$day\b', caseSensitive: false), '').trim();
    }

    // Parse time
    if (RegExp(r'\b(at|by) \d{1,2}(:\d{2})? (am|pm)\b').hasMatch(input.toLowerCase())) {
      final timeMatch = RegExp(r'\b\d{1,2}(:\d{2})? (am|pm)\b').firstMatch(input.toLowerCase());
      final timeStr = timeMatch?.group(0);
      if (timeStr != null) {
        final time = _parseTimeString(timeStr);
        dueDate = DateTime(dueDate.year, dueDate.month, dueDate.day, time.hour, time.minute);
        title = title.replaceAll(RegExp(r'\b(at|by) $timeStr\b', caseSensitive: false), '').trim();
      }
    }

    // Parse location
    if (input.toLowerCase().contains(" at ")) {
      final locationParts = input.split(" at ");
      if (locationParts.length > 1) {
        title = locationParts[0].trim();
        location = locationParts[1].trim();
      }
    }

    // Parse notes (after semicolon)
    if (input.contains(";")) {
      final noteParts = input.split(";");
      if (noteParts.length > 1) {
        title = noteParts[0].trim();
        notes = noteParts[1].trim();
      }
    }

    // Enhanced categorization
    category = _categorizeTask(title);

    // Priority detection
    priority = _determinePriority(title);

    return {
      'title': title,
      'dueDate': dueDate,
      'category': category,
      'priority': priority,
      'notes': notes,
      'location': location,
    };
  }

  int _daysUntilNext(String dayName) {
    final now = DateTime.now();
    final today = now.weekday;
    final days = {
      'monday': 1,
      'tuesday': 2,
      'wednesday': 3,
      'thursday': 4,
      'friday': 5,
      'saturday': 6,
      'sunday': 7,
    };
    
    final targetDay = days[dayName.toLowerCase()]!;
    var daysToAdd = targetDay - today;
    if (daysToAdd <= 0) daysToAdd += 7;
    return daysToAdd;
  }

  TimeOfDay _parseTimeString(String timeStr) {
    final parts = timeStr.split(' ');
    final period = parts[1].toLowerCase();
    final timeParts = parts[0].split(':');
    
    var hour = int.parse(timeParts[0]);
    final minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;
    
    if (period == 'pm' && hour < 12) hour += 12;
    if (period == 'am' && hour == 12) hour = 0;
    
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _categorizeTask(String title) {
    final lowerTitle = title.toLowerCase();
    
    final categoryPatterns = {
      'Health': ['health', 'doctor', 'appointment', 'medicine', 'hospital'],
      'Work': ['work', 'project', 'meeting', 'deadline', 'office', 'boss'],
      'Academics': ['study', 'lecture', 'assignment', 'exam', 'homework', 'school', 'college'],
      'Social': ['meet', 'social', 'party', 'dinner', 'lunch', 'friend', 'family'],
      'Personal': ['home', 'chore', 'clean', 'laundry', 'groceries', 'shopping', 'buy'],
      'Finance': ['pay', 'bill', 'invoice', 'bank', 'transfer', 'money'],
      'Fitness': ['gym', 'run', 'workout', 'exercise', 'yoga', 'swim'],
    };
    
    for (final entry in categoryPatterns.entries) {
      if (entry.value.any((pattern) => lowerTitle.contains(pattern))) {
        return entry.key;
      }
    }
    
    return 'General';
  }

  int _determinePriority(String title) {
    if (title.toLowerCase().contains('urgent') || 
        title.toLowerCase().contains('important')) {
      return 5;
    } else if (title.contains('!')) {
      return 4;
    } else if (title.toLowerCase().contains('high priority')) {
      return 4;
    } else if (title.toLowerCase().contains('low priority')) {
      return 2;
    }
    return 3;
  }

   final FlutterLocalNotificationsPlugin notificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  // Add this method to cancel reminders for a specific task
  Future<void> cancelTaskReminders(String taskId) async {
    try {
      // Cancel all notifications for this task
      // Using the task's hashCode as the notification ID
      await notificationsPlugin.cancel(taskId.hashCode);
      
      // If you have multiple reminders per task, you might need to cancel a range:
      // for (int i = taskId.hashCode; i < taskId.hashCode + 5; i++) {
      //   await notificationsPlugin.cancel(i);
      // }
      
      Get.snackbar(
        'Reminders Cancelled',
        'Notifications for this task have been removed',
        snackPosition: SnackPosition.BOTTOM,
      );} catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel reminders: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

 

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
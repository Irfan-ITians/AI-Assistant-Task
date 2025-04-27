import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart';
import 'package:personal_ai_assistant/widgets/remainder_card.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to reminder settings
              // Get.toNamed('/reminder-settings');
            },
          ),
        ],
      ),
      body: Obx(() {
        final upcomingTasks = taskController.tasks
            .where((t) => !t.isCompleted && t.dueDate.isAfter(DateTime.now()))
            .toList()
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
        
        if (upcomingTasks.isEmpty) {
          return const Center(
            child: Text('No upcoming reminders - add some tasks!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: upcomingTasks.length, 
          itemBuilder: (context, index) {
            final task = upcomingTasks[index];
            return ReminderCard(
              task: task,
              onDismissed: () {
                // Handle reminder dismissal
                taskController.cancelTaskReminders(task.id);
              },
              onTap: () {
                // Show task details
                // Get.toNamed('/task-details', arguments: task.id);
              },
            );
          },
        );
      }),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_ai_assistant/controller/dashboard_controller.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart';
import 'package:personal_ai_assistant/models/task/task_model.dart';

class ReminderCard extends StatelessWidget {
  final Task task;
  final Function()? onDismissed;
  final Function()? onTap;

  const ReminderCard({
    super.key,
    required this.task,
    this.onDismissed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timeLeft = task.dueDate.difference(DateTime.now());
    final taskController = Get.find<TaskController>();
    final mood = Get.find<DashboardController>().mood.value;

    String _formatDuration(Duration duration) {
      if (duration.inDays > 0) {
        return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
      } else if (duration.inHours > 0) {
        return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
      } else {
        return 'less than an hour';
      }
    }

    String reminderText;
    if (mood == '😊') {
      reminderText = 'You got this! Due in ${_formatDuration(timeLeft)}';
    } else if (mood == '😞') {
      reminderText = 'No rush - due in ${_formatDuration(timeLeft)}';
    } else {
      reminderText = 'Due in ${_formatDuration(timeLeft)}';
    }

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await Get.defaultDialog(
          title: "Remove Reminder?",
          middleText: "This will stop notifications for this task",
          textConfirm: "Remove",
          textCancel: "Keep",
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );
      },
      onDismissed: (_) => onDismissed?.call(),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(
            task.priority >= 4 ? Icons.warning_amber : Icons.notifications,
            color: task.priority >= 4 ? Colors.orange : Colors.blue,
          ),
          title: Text(task.title),
          subtitle: Text(reminderText),
          trailing: Chip(
            label: Text(task.category),
            backgroundColor: _getCategoryColor(task.category),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Health':
        return Colors.red[100]!;
      case 'Work':
        return Colors.blue[100]!;
      case 'Academics':
        return Colors.purple[100]!;
      case 'Social':
        return Colors.green[100]!;
      case 'Personal':
        return Colors.orange[100]!;
      case 'Finance':
        return Colors.teal[100]!;
      case 'Fitness':
        return Colors.deepOrange[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}
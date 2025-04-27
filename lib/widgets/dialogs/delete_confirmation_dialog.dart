// lib/widgets/dialogs/delete_confirmation_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/models/task/task_model.dart';

import '../../controller/task_controller.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Task task;

  const DeleteConfirmationDialog({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Task"),
      content: Text("Are you sure you want to delete this task?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Get.find<TaskController>().deleteTask(task.id);
            Get.back();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.red,
          ),
          child: Text("Delete"),
        ),
      ],
    );
  }
}
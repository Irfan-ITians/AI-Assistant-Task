// lib/widgets/dialogs/task_details_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_ai_assistant/models/task/task_model.dart';

class TaskDetailsDialog extends StatelessWidget {
  final Task task;

  const TaskDetailsDialog({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Task Details"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(task.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildDetailRow(Icons.calendar_today, 
                "Due: ${DateFormat.yMMMd().add_jm().format(task.dueDate)}"),
            _buildDetailRow(Icons.category, "Category: ${task.category}"),
            _buildDetailRow(Icons.star, "Priority: ${'★' * task.priority}"),
            if (task.location != null) 
              _buildDetailRow(Icons.location_on, "Location: ${task.location}"),
            if (task.notes != null) ...[
              SizedBox(height: 12),
              Text("Notes:", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(task.notes!),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Close"),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
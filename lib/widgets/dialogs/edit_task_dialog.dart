// lib/widgets/dialogs/edit_task_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart';
import 'package:personal_ai_assistant/models/task/task_model.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;

  const EditTaskDialog({Key? key, required this.task}) : super(key: key);

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController titleController;
  late TextEditingController notesController;
  late TextEditingController locationController;
  late String selectedCategory;
  late int selectedPriority;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    notesController = TextEditingController(text: widget.task.notes ?? '');
    locationController = TextEditingController(text: widget.task.location ?? '');
    selectedCategory = widget.task.category;
    selectedPriority = widget.task.priority;
    selectedDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    notesController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                _buildTitleField(),
                SizedBox(height: 12),
                _buildNotesField(),
                SizedBox(height: 12),
                _buildLocationField(),
                SizedBox(height: 12),
                _buildCategoryDropdown(),
                SizedBox(height: 12),
                _buildPriorityDropdown(),
                SizedBox(height: 12),
                _buildDatePicker(),
                _buildTimePicker(),
                SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: notesController,
      decoration: InputDecoration(
        labelText: 'Notes',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: locationController,
      decoration: InputDecoration(
        labelText: 'Location',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isDense: true,
          onChanged: (value) => setState(() => selectedCategory = value!),
          items: [
            'General', 'Health', 'Work', 'Academics',
            'Social', 'Personal', 'Finance', 'Fitness'
          ].map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Priority',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedPriority,
          isDense: true,
          onChanged: (value) => setState(() => selectedPriority = value!),
          items: [1, 2, 3, 4, 5].map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text('${'★' * value}'),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text('Due Date'),
      subtitle: Text(DateFormat.yMMMd().format(selectedDate)),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            selectedDate = DateTime(
              picked.year,
              picked.month,
              picked.day,
              selectedDate.hour,
              selectedDate.minute,
            );
          });
        }
      },
    );
  }

  Widget _buildTimePicker() {
    return ListTile(
      title: Text('Time'),
      subtitle: Text(DateFormat.jm().format(selectedDate)),
      trailing: Icon(Icons.access_time),
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDate),
        );
        if (picked != null) {
          setState(() {
            selectedDate = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              picked.hour,
              picked.minute,
            );
          });
        }
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            final updatedTask = widget.task.copyWith(
              title: titleController.text,
              notes: notesController.text.isEmpty ? null : notesController.text,
              location: locationController.text.isEmpty ? null : locationController.text,
              category: selectedCategory,
              priority: selectedPriority,
              dueDate: selectedDate,
            );
            Get.find<TaskController>().editTask(widget.task.id, updatedTask);
            Get.back();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
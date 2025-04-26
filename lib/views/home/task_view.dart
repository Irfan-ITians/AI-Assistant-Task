
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskCreationPage extends StatelessWidget {
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              taskController.isListening.value ? Icons.mic_off : Icons.mic,
            )),
            onPressed: () {
              if (taskController.isListening.value) {
                taskController.stopListening();
              } else {
                taskController.startListening();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: taskController.taskInputController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                hintText: 'e.g., "Submit project by tomorrow at 3pm"',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text('Or select due date manually:', style: TextStyle(fontSize: 16)),
            Obx(() => TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: taskController.selectedDate.value,
              selectedDayPredicate: (day) => 
                taskController.isSameDay(day, taskController.selectedDate.value),
              onDaySelected: (selectedDay, _) => 
                taskController.updateSelectedDate(selectedDay),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            )),
            // const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (taskController.taskInputController.text.trim().isNotEmpty) {
                    taskController.addTaskFromInput(
                      taskController.taskInputController.text.trim(),
                    );
                    taskController.taskInputController.clear();
                    Get.back();
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please enter a task description',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text('Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
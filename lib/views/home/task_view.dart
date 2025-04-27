
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart';
import 'package:personal_ai_assistant/controller/speech_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskCreationPage extends StatefulWidget {
  const TaskCreationPage({Key? key}) : super(key: key);

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  final TaskController taskController = Get.find();
  final SpeechController speechController = Get.put(SpeechController());

 @override
void initState() {
  super.initState();
  // Now using the RxString directly
 ever(speechController.recognizedTextRx, (String? text) {
  if (text != null && text.isNotEmpty) {
    taskController.updateFromSpeech(text);
  }
});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
        actions: [
          Obx(() => IconButton(
            icon: Icon(speechController.isListening ? Icons.mic_off : Icons.mic),
            onPressed: () {
              if (speechController.isListening) {
                speechController.stopListening();
              } else {
                speechController.startListening();
              }
            },
          )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: taskController.taskInputController,
              decoration: InputDecoration(
                labelText: 'Task Description',
                hintText: 'e.g., "Submit project by tomorrow at 3pm"',
                border: const OutlineInputBorder(),
                suffixIcon: Obx(() => speechController.isListening
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      )
                    : const SizedBox.shrink()),
              ),
              maxLines: 3,
            ),
            
            Obx(() => speechController.isListening
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Listening...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : const SizedBox.shrink()),

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
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            )),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (taskController.taskInputController.text.trim().isNotEmpty) {
                    final success = await taskController.addTaskFromInput(
                      taskController.taskInputController.text.trim(),
                    );
                    if (success) {
                      taskController.taskInputController.clear();
                      speechController.clearRecognizedText();
                      Get.back();
                    }
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
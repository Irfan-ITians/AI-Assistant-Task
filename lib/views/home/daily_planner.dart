
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart';
import 'package:personal_ai_assistant/models/task/task_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'task_view.dart';

class DailyPlannerScreen extends StatelessWidget {
  final TaskController taskController = Get.find();
  final Rx<CalendarFormat> calendarFormat = CalendarFormat.week.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planner"),
        actions: [
          Obx(() => IconButton(
            icon: Icon(calendarFormat.value == CalendarFormat.month 
                ? Icons.calendar_view_day 
                : Icons.calendar_view_month),
            onPressed: () {
              calendarFormat.value = calendarFormat.value == CalendarFormat.month
                  ? CalendarFormat.week
                  : CalendarFormat.month;
            },
          )),
        ],
      ),
      body: Obx(() {
        if (!taskController.isInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: taskController.selectedDate.value,
              selectedDayPredicate: (day) =>
                  taskController.isSameDay(day, taskController.selectedDate.value),
              onDaySelected: (selectedDay, _) =>
                  taskController.updateSelectedDate(selectedDay),
              calendarFormat: calendarFormat.value,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final taskCount = taskController.tasks
                      .where((task) => taskController.isSameDay(task.dueDate, date))
                      .length;
                  return taskCount > 0
                      ? Positioned(
                          bottom: 1,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$taskCount',
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        )
                      : null;
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            Expanded(
              child: _buildTaskList(),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => TaskCreationPage()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      if (taskController.filteredTasks.isEmpty) {
        return Center(child: Text("No tasks for ${DateFormat.yMMMd().format(taskController.selectedDate.value)}"));
      }

      return ReorderableListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: taskController.filteredTasks.length,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) newIndex--;
          final task = taskController.filteredTasks.removeAt(oldIndex);
          taskController.filteredTasks.insert(newIndex, task);
        },
        itemBuilder: (context, index) {
          final task = taskController.filteredTasks[index];
          return Dismissible(
            key: Key(task.id),
            background: Container(color: Colors.red),
            secondaryBackground: Container(color: Colors.blue),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                _showEditDialog(task);
                return false;
              }
              return true;
            },
            onDismissed: (_) => taskController.deleteTask(task.id),
            child: Card(
              key: ValueKey(task.id),
              child: ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) =>
                      taskController.toggleTaskCompletion(task.id),
                ),
                title: Text(task.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.category != 'General')
                      Chip(
                        label: Text(task.category),
                        backgroundColor: _getCategoryColor(task.category),
                      ),
                    if (task.location != null)
                      Text('📍 ${task.location}'),
                    Text(
                      DateFormat.jm().format(task.dueDate),
                      style: TextStyle(
                        color: task.dueDate.isBefore(DateTime.now()) && !task.isCompleted
                            ? Colors.red
                            : null,
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.drag_handle),
                onTap: () => _showTaskDetails(task),
              ),
            ),
          );
        },
      );
    });
  }

  void _showEditDialog(Task task) {
    final controller = TextEditingController(text: task.title);
    
    Get.defaultDialog(
      title: "Edit Task",
      content: TextField(controller: controller),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            taskController.taskBox.put(task.id, task.copyWith(title: controller.text));
            taskController.loadTasks();
            Get.back();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  void _showTaskDetails(Task task) {
    Get.defaultDialog(
      title: "Task Details",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("Due: ${DateFormat.yMMMd().add_jm().format(task.dueDate)}"),
          Text("Category: ${task.category}"),
          Text("Priority: ${'★' * task.priority}"),
          if (task.location != null) Text("Location: ${task.location}"),
          if (task.notes != null) ...[
            const SizedBox(height: 10),
            const Text("Notes:"),
            Text(task.notes!),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Close"),
        ),
      ],
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


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_ai_assistant/controller/dashboard_controller.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart';
import 'package:personal_ai_assistant/views/home/daily_planner.dart';
import 'package:personal_ai_assistant/views/home/remainder.dart';
import 'package:personal_ai_assistant/widgets/dashboard_tile.dart';
import 'package:personal_ai_assistant/widgets/remainder_card.dart';

import 'task_view.dart';

class DashboardView extends StatelessWidget {
  final DashboardController dashboardController = Get.put(DashboardController());
  final TaskController taskController = Get.find();

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dashboardController.formattedDate()),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => Get.to(() => DailyPlannerScreen()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood Tracker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('How are you feeling today?',
                        style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Obx(() => Wrap(
                          spacing: 8,
                          children: dashboardController.availableMoods.map((m) {
                            return ChoiceChip(
                              label: Text(m, style: const TextStyle(fontSize: 20)),
                              selected: dashboardController.mood.value == m,
                              onSelected: (_) => dashboardController.updateMood(m),
                            );
                          }).toList(),
                        )),
                    const SizedBox(height: 10),
                    Obx(() => Text(
                          dashboardController.productivityTip,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600]),
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Summary Grid
            Obx(() => GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    DashboardTile(
                      icon: Icons.task,
                      title: "Tasks",
                      content: dashboardController.taskSummary,
                      color: Colors.blue[100]!,
                      onTap: () => Get.to(() => DailyPlannerScreen()),
                    ),
                    DashboardTile(
                      icon: Icons.emoji_emotions,
                      title: "Current Mood",
                      content: dashboardController.mood.value,
                      color: Colors.pink[100]!,
                    ),
                    GestureDetector(
                      child: DashboardTile(
                        icon: Icons.star,
                        title: "Reminders",
                        content: "${taskController.tasks.where((t) => t.priority >= 4).length} urgent",
                        color: Colors.orange[100]!,
                        onTap: () => Get.to(() => RemindersScreen()),
                      ),
                    ),
                    DashboardTile(
                      icon: Icons.check_circle,
                      title: "Summarizer",
                      content: "${taskController.tasks.where((t) => t.isCompleted).length}/${taskController.tasks.length} done",
                      color: Colors.green[100]!,
                    ),
                  ],
                )),

            const SizedBox(height: 20),

            const Text('Recent Tasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            // Recent Tasks
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: taskController.tasks.take(3).length,
                  itemBuilder: (context, index) {
                    final task = taskController.tasks[index];
                    return ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => taskController.toggleTaskCompletion(task.id),
                      ),
                      title: Text(task.title),
                      subtitle:
                          Text("Due: ${DateFormat.MMMd().format(task.dueDate)}"),
                      trailing: Chip(
                        label: Text(task.category),
                        backgroundColor: _getCategoryColor(task.category),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => TaskCreationPage()),
        child: const Icon(Icons.add),
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

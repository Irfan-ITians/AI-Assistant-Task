

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:personal_ai_assistant/controller/dashboard_controller.dart';
// import 'package:personal_ai_assistant/controller/task_controller.dart';
// import 'package:personal_ai_assistant/views/home/daily_planner.dart';
// import 'package:personal_ai_assistant/views/home/remainder.dart';
// import 'package:personal_ai_assistant/widgets/dashboard_tile.dart';
// import 'package:personal_ai_assistant/widgets/dialogs/task_details_dialog.dart';
// import 'package:personal_ai_assistant/widgets/remainder_card.dart';

// import '../../controller/theme_controller.dart';
// import '../../utilities/contants.dart';
// import '../../widgets/scan_button.dart';
// import '../../widgets/theme_menu.dart';
// import 'task_view.dart';

// class DashboardView extends StatelessWidget {
//   final DashboardController dashboardController = Get.put(DashboardController());
//   final TaskController taskController = Get.find();
//     final themeController = Get.find<ThemeController>();
//   DashboardView({super.key});
// DropdownMenuItem<ThemeMode> _buildThemeDropdownItem(
//     ThemeMode mode, IconData icon, String text) {
//   return DropdownMenuItem(
//     value: mode,
//     child: Row(
//       children: [
//         Icon(icon, size: 22, color: Colors.deepPurple),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         if (themeController.themeMode.value == mode)
//           Icon(Icons.check, size: 18, color: Colors.green),
//       ],
//     ),
//   );
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(dashboardController.formattedDate()),
//         actions: [
//           AppBarThemeMenu(themeController: themeController),
//           IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: () => Get.to(() => DailyPlannerScreen()),
//           ),
//         ],
//       ),
//        body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Mood Tracker
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('How are you feeling today?',
//                         style: TextStyle(fontSize: 18)),
//                     const SizedBox(height: 10),
//                     Obx(() => Wrap(
//                           spacing: 8,
//                           children: dashboardController.availableMoods.map((m) {
//                             return ChoiceChip(
//                               label: Text(m, style: const TextStyle(fontSize: 20)),
//                               selected: dashboardController.mood.value == m,
//                               onSelected: (_) => dashboardController.updateMood(m),
//                             );
//                           }).toList(),
//                         )),
//                     const SizedBox(height: 10),
//                     Obx(() => Text(
//                           dashboardController.productivityTip,
//                           style: TextStyle(
//                               fontStyle: FontStyle.italic,
//                               color: Colors.grey[600]),
//                         )),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Summary Grid
//             Obx(() => GridView.count(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisCount: 2,
//                   childAspectRatio: 1,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   children: [
//                     DashboardTile(
//                       icon: Icons.task,
//                       title: "Tasks",
//                       content: dashboardController.taskSummary,
//                       color: Colors.blue[100]!,
//                       onTap: () => Get.to(() => DailyPlannerScreen()),
//                     ),
//                     DashboardTile(
//                       icon: Icons.emoji_emotions,
//                       title: "Current Mood",
//                       content: dashboardController.mood.value,
//                       color: Colors.pink[100]!,
//                     ),
//                     GestureDetector(
//                       child: DashboardTile(
//                         icon: Icons.star,
//                         title: "Reminders",
//                         content: "${taskController.tasks.where((t) => t.priority >= 4).length} urgent",
//                         color: Colors.orange[100]!,
//                         onTap: () => Get.to(() => RemindersScreen()),
//                       ),
//                     ),
//                     DashboardTile(
//                       icon: Icons.check_circle,
//                       title: "Summarizer",
//                       content: "${taskController.tasks.where((t) => t.isCompleted).length}/${taskController.tasks.length} done",
//                       color: Colors.green[100]!,
//                     ),
//                   ],
//                 )),

// const SizedBox(height: 20),

// const Text('Recent Tasks',
//     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

// const SizedBox(height: 8),
// Obx(() {
//   final recentTasks = taskController.tasks.length <= 3 
//       ? taskController.tasks.toList()
//       : taskController.tasks.sublist(taskController.tasks.length - 3);
  
//   return ListView.builder(
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     itemCount: recentTasks.length,
//     itemBuilder: (context, index) {
//       final task = recentTasks[index];
//       return ListTile(
//         leading: Checkbox(
//           value: task.isCompleted,
//           onChanged: (_) => taskController.toggleTaskCompletion(task.id),
//         ),
//         title: Text(task.title),
//         subtitle: Text("Due: ${DateFormat.MMMd().format(task.dueDate)}"),
//         trailing: Chip(
//           label: Text(task.category),
//           backgroundColor: getCategoryColor(task.category),
//         ),
//       );
//     },
//   );
// }),
//           ],
//         ),
//       ),
//       //   floatingActionButton: const ScanTaskButton(),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () => Get.to(() => TaskCreationPage()),
//       //   child: const Icon(Icons.add),
//       // ),
//       floatingActionButton: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FloatingActionButton(
//             heroTag: 'scanButton',
//             onPressed: () => ScanTaskButton(),
//             mini: true,
//             child: const Icon(Icons.camera_alt),),
//           const SizedBox(height: 8),
//           FloatingActionButton(
//             heroTag: 'addButton',
//             onPressed: () => Get.to(() => TaskCreationPage()),
//             child: const Icon(Icons.add),
//           ),
//         ],
//       ),
//     );
//   }

  
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:personal_ai_assistant/controller/dashboard_controller.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart';
import 'package:personal_ai_assistant/views/home/daily_planner.dart';
import 'package:personal_ai_assistant/views/home/remainder.dart';
import 'package:personal_ai_assistant/widgets/dashboard_tile.dart';
import '../../controller/theme_controller.dart';
import '../../widgets/theme_menu.dart';
import 'task_view.dart';

class DashboardView extends StatelessWidget {
  final DashboardController dashboardController = Get.put(DashboardController());
  final TaskController taskController = Get.find();
  final themeController = Get.find<ThemeController>();

  DashboardView({super.key});

  void _showScanOptions(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                taskController.addTaskFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                taskController.addTaskFromGallery();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dashboardController.formattedDate()),
        actions: [
          AppBarThemeMenu(themeController: themeController),
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
                      onTap: () => Get.to(() => RemindersScreen()),
                      child: DashboardTile(
                        icon: Icons.star,
                        title: "Reminders",
                        content: "${taskController.tasks.where((t) => t.priority >= 4).length} urgent",
                        color: Colors.orange[100]!,
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
            Obx(() {
              final recentTasks = taskController.tasks.take(3).toList();
              
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentTasks.length,
                itemBuilder: (context, index) {
                  final task = recentTasks[index];
                  return ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => taskController.toggleTaskCompletion(task.id),
                    ),
                    title: Text(task.title),
                    subtitle: Text("Due: ${DateFormat.MMMd().format(task.dueDate)}"),
                    trailing: Chip(
                      label: Text(task.category),
                      backgroundColor: _getCategoryColor(task.category),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'scanButton',
            onPressed: () => _showScanOptions(context),
            mini: true,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addButton',
            onPressed: () => Get.to(() => TaskCreationPage()),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Colors.blue[200]!;
      case 'personal':
        return Colors.green[200]!;
      case 'health':
        return Colors.red[200]!;
      case 'social':
        return Colors.purple[200]!;
      default:
        return Colors.grey[200]!;
    }
  }
}

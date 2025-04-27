import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_ai_assistant/controller/task_controller.dart' show TaskController;

class ScanTaskButton extends StatelessWidget {
  const ScanTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    
    return FloatingActionButton.extended(
      onPressed: () {
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
      },
      icon: const Icon(Icons.camera_alt),
      label: const Text('Scan Task'),
      heroTag: 'scanTask',
    );
  }
}
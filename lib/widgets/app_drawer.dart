import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/theme_controller.dart';

class AppDrawer extends StatelessWidget {
  final ThemeController themeController;

  const AppDrawer({
    Key? key,
    required this.themeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: Obx(() {
                    return DropdownButton<ThemeMode>(
                      isExpanded: true,
                      value: themeController.themeMode.value,
                      items: [
                        _buildThemeDropdownItem(
                          ThemeMode.system,
                          Icons.brightness_auto,
                          'System Theme',
                          themeController.themeMode.value,
                        ),
                        _buildThemeDropdownItem(
                          ThemeMode.light,
                          Icons.light_mode,
                          'Light Theme',
                          themeController.themeMode.value,
                        ),
                        _buildThemeDropdownItem(
                          ThemeMode.dark,
                          Icons.dark_mode,
                          'Dark Theme',
                          themeController.themeMode.value,
                        ),
                      ],
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeController.changeThemeMode(value);
                        }
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<ThemeMode> _buildThemeDropdownItem(
      ThemeMode mode, IconData icon, String text, ThemeMode currentMode) {
    return DropdownMenuItem(
      value: mode,
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (currentMode == mode)
            Icon(Icons.check, size: 18, color: Colors.green),
        ],
      ),
    );
  }
}

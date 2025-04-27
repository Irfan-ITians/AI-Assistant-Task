import 'package:flutter/material.dart';
import '../controller/theme_controller.dart';

class AppBarThemeMenu extends StatelessWidget {
  final ThemeController themeController;

  const AppBarThemeMenu({Key? key, required this.themeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton<ThemeMode>(
        onSelected: (ThemeMode selectedMode) {
          themeController.changeThemeMode(selectedMode);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.system,
            child: _buildMenuItem(
              context,
              icon: Icons.brightness_auto,
              text: 'System Theme',
              isSelected: themeController.themeMode.value == ThemeMode.system,
            ),
          ),
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.light,
            child: _buildMenuItem(
              context,
              icon: Icons.light_mode,
              text: 'Light Theme',
              isSelected: themeController.themeMode.value == ThemeMode.light,
            ),
          ),
          PopupMenuItem<ThemeMode>(
            value: ThemeMode.dark,
            child: _buildMenuItem(
              context,
              icon: Icons.dark_mode,
              text: 'Dark Theme',
              isSelected: themeController.themeMode.value == ThemeMode.dark,
            ),
          ),
        ],
      );
   
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon, required String text, required bool isSelected}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.deepPurple),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        if (isSelected)
          const Icon(Icons.check, size: 18, color: Colors.green),
      ],
    );
  }
}

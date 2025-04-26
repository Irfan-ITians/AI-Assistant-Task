import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;
  final VoidCallback? onTap;

  const DashboardTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          height: 140, // <-- Fixed height to prevent overflow
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // keeps column small
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // if title is long
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // if content is long
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

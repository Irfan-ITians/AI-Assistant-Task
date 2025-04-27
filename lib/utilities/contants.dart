import 'dart:ui';

import 'package:flutter/material.dart';

Color getCategoryColor(String category) {
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
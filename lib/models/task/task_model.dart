import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  DateTime dueDate;
  
  @HiveField(3)
  String category;
  
  @HiveField(4)
  int priority;
  
  @HiveField(5)
  bool isCompleted;
  
  @HiveField(6)
  String? notes;
  
  @HiveField(7)
  String? location;

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.category,
    this.priority = 3,
    this.isCompleted = false,
    this.notes,
    this.location,
  });

  Task copyWith({
    String? title,
    DateTime? dueDate,
    String? category,
    int? priority,
    bool? isCompleted,
    String? notes,
    String? location,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
      location: location ?? this.location,
    );
  }
}
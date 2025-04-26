
// import 'package:hive/hive.dart';

// part 'task_model.g.dart';

// @HiveType(typeId: 0)
// class Task {
//   @HiveField(0) final String id;
//   @HiveField(1) final String title;
//   @HiveField(2) final DateTime dueDate;
//   @HiveField(3) final String category;
//   @HiveField(4) bool isCompleted;
//   @HiveField(5) int priority;
//   @HiveField(6) List<String> tags;
//   @HiveField(7) String? notes;

//   Task({
//     required this.id,
//     required this.title,
//     required this.dueDate,
//     required this.category,
//     this.isCompleted = false,
//     this.priority = 3,
//     this.tags = const [],
//     this.notes,
//   });

//   Task copyWith({
//     String? title,
//     DateTime? dueDate,
//     String? category,
//     bool? isCompleted,
//     int? priority,
//     List<String>? tags,
//     String? notes,
//   }) {
//     return Task(
//       id: id,
//       title: title ?? this.title,
//       dueDate: dueDate ?? this.dueDate,
//       category: category ?? this.category,
//       isCompleted: isCompleted ?? this.isCompleted,
//       priority: priority ?? this.priority,
//       tags: tags ?? this.tags,
//       notes: notes ?? this.notes,
//     );
//   }
// }
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
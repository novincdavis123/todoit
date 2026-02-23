import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.category,
    required super.dueDate,
    required super.priority,
    required super.isCompleted,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json['id'],
    title: json['title'],
    category: json['category'],
    dueDate: DateTime.parse(json['due_date']),
    priority: json['priority'],
    isCompleted: json['is_completed'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'due_date': dueDate.toIso8601String(),
    'priority': priority,
    'is_completed': isCompleted,
  };
}

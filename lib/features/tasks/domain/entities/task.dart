class Task {
  final String id;
  final String title;
  final String category;
  final int priority;
  final DateTime dueDate;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
  });

  Task copyWith({
    String? id,
    String? title,
    String? category,
    int? priority,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

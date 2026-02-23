class Task {
  final String id;
  final String title;
  final String category;
  final DateTime dueDate;
  final int priority;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
  });

  Task copyWith({
    String? title,
    String? category,
    DateTime? dueDate,
    int? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

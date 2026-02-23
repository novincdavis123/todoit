import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoit/features/tasks/domain/usecases/task_usecase.dart';
import '../../domain/entities/task.dart';

enum TaskStatus { initial, loading, success, error }

class TaskState {
  final List<Task> tasks;
  final TaskStatus status;
  final String? error;

  TaskState({
    this.tasks = const [],
    this.status = TaskStatus.initial,
    this.error,
  });

  TaskState copyWith({List<Task>? tasks, TaskStatus? status, String? error}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

class TaskNotifier extends Notifier<TaskState> {
  late final FetchTasksUseCase fetchTasksUseCase;
  late final AddTaskUseCase addTaskUseCase;
  late final UpdateTaskUseCase updateTaskUseCase;

  @override
  TaskState build() {
    return TaskState();
  }

  // --- Load tasks ---
  Future<void> loadTasks(String userId) async {
    state = state.copyWith(status: TaskStatus.loading);
    try {
      final tasks = await fetchTasksUseCase(userId: userId);
      state = state.copyWith(status: TaskStatus.success, tasks: tasks);
    } catch (e) {
      state = state.copyWith(status: TaskStatus.error, error: e.toString());
    }
  }

  // --- Add new task ---
  Future<void> addTask(Task task, String userId) async {
    try {
      await addTaskUseCase(task, userId);
      await loadTasks(userId); // refresh after adding
    } catch (e) {
      state = state.copyWith(status: TaskStatus.error, error: e.toString());
    }
  }

  // --- Update task ---
  Future<void> updateTask(Task task, String userId) async {
    try {
      await updateTaskUseCase(task, userId);
      // Update locally to avoid refetching all tasks
      final updatedTasks = state.tasks
          .map((t) => t.id == task.id ? task : t)
          .toList();
      state = state.copyWith(tasks: updatedTasks);
    } catch (e) {
      state = state.copyWith(status: TaskStatus.error, error: e.toString());
    }
  }
}

/// Provider
final taskProvider = NotifierProvider<TaskNotifier, TaskState>(
  () => TaskNotifier(),
);

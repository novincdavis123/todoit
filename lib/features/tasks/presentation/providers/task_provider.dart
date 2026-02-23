import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  /// Helper to get current user ID
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  /// Load tasks for current user
  Future<void> loadTasksForCurrentUser() async {
    final userId = currentUserId;
    if (userId == null) return;

    state = state.copyWith(status: TaskStatus.loading);
    try {
      final tasks = await fetchTasksUseCase(userId: userId);
      state = state.copyWith(status: TaskStatus.success, tasks: tasks);
    } catch (e) {
      state = state.copyWith(status: TaskStatus.error, error: e.toString());
    }
  }

  /// Add task for current user
  Future<void> addTaskForCurrentUser(Task task) async {
    final userId = currentUserId;
    if (userId == null) return;

    state = state.copyWith(status: TaskStatus.loading);
    try {
      // addTaskUseCase should return the Task with proper Firestore ID
      final newTask = await addTaskUseCase(task, userId);
      state = state.copyWith(
        status: TaskStatus.success,
        tasks: [...state.tasks, newTask],
      );
    } catch (e) {
      state = state.copyWith(status: TaskStatus.error, error: e.toString());
    }
  }

  /// Update task for current user
  Future<void> updateTaskForCurrentUser(Task task) async {
    final userId = currentUserId;
    if (userId == null) return;

    try {
      await updateTaskUseCase(task, userId);
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

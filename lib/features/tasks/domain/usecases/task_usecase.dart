import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Fetch tasks with optional pagination
class FetchTasksUseCase {
  final TaskRepository repository;
  FetchTasksUseCase(this.repository);

  Future<List<Task>> call({
    required String userId,
    int skip = 0,
    int limit = 10,
  }) {
    return repository.fetchTasks(userId: userId, skip: skip, limit: limit);
  }
}

/// Add a new task
class AddTaskUseCase {
  final TaskRepository repository;
  AddTaskUseCase(this.repository);

  Future<void> call(Task task, String userId) {
    return repository.addTask(task, userId);
  }
}

/// Update an existing task
class UpdateTaskUseCase {
  final TaskRepository repository;
  UpdateTaskUseCase(this.repository);

  Future<void> call(Task task, String userId) {
    return repository.updateTask(task, userId);
  }
}

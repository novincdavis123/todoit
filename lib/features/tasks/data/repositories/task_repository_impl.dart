import 'package:todoit/features/tasks/data/datasources/local_datasource.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;
  final TaskLocalDataSource local;

  TaskRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<Task>> fetchTasks({
    required String userId,
    int skip = 0,
    int limit = 10,
  }) async {
    try {
      final tasks = await remote.fetchTasks(userId, skip, limit);
      await local.cacheTasks(tasks);
      return tasks;
    } catch (_) {
      // fallback to local cache
      return await local.getCachedTasks();
    }
  }

  @override
  Future<void> addTask(Task task, String userId) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      category: task.category,
      dueDate: task.dueDate,
      priority: task.priority,
      isCompleted: task.isCompleted,
    );
    await remote.addTask(taskModel, userId);
  }

  @override
  Future<void> updateTask(Task task, String userId) async {
    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      category: task.category,
      dueDate: task.dueDate,
      priority: task.priority,
      isCompleted: task.isCompleted,
    );
    await remote.updateTask(taskModel, userId);
  }

  @override
  Future<void> deleteTask(String taskId, String userId) async {
    await remote.deleteTask(taskId, userId);
  }
}

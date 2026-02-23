import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks({
    required String userId,
    int skip = 0,
    int limit = 10,
  });
  Future<void> addTask(Task task, String userId);
  Future<void> updateTask(Task task, String userId);
  Future<void> deleteTask(String taskId, String userId);
}

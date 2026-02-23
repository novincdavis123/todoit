import '../entities/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TaskRepository {
  Future<List<Task>> fetchTasks({required String userId, int skip, int limit});

  // Return DocumentReference to get the generated ID
  Future<DocumentReference> addTask(Task task, String userId);

  Future<void> updateTask(Task task, String userId);
  Future<void> deleteTask(String taskId, String userId);
}

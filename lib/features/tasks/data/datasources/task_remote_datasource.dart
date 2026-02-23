import 'package:dio/dio.dart';
import 'package:todoit/core/error/app_exceptions.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  final Dio dio;
  TaskRemoteDataSource({required this.dio});

  Future<List<TaskModel>> fetchTasks(String userId, int skip, int limit) async {
    try {
      final response = await dio.get(
        '/tasks/',
        queryParameters: {'user_id': userId, 'skip': skip, 'limit': limit},
      );

      final data = response.data as List;
      return data.map((e) => TaskModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw NetworkException('Failed to fetch tasks: ${e.message}');
    }
  }

  Future<void> addTask(TaskModel task, String userId) async {
    try {
      await dio.post(
        '/tasks/',
        queryParameters: {'user_id': userId},
        data: task.toJson(),
      );
    } catch (e) {
      throw ServerException('Failed to add task');
    }
  }

  Future<void> updateTask(TaskModel task, String userId) async {
    try {
      await dio.put(
        '/tasks/${task.id}',
        queryParameters: {'user_id': userId},
        data: task.toJson(),
      );
    } catch (e) {
      throw ServerException('Failed to update task');
    }
  }

  Future<void> deleteTask(String taskId, String userId) async {
    try {
      await dio.delete('/tasks/$taskId', queryParameters: {'user_id': userId});
    } catch (e) {
      throw ServerException('Failed to delete task');
    }
  }
}

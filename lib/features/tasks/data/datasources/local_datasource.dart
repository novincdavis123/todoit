import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  static const String boxName = 'tasksBox';

  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final box = await Hive.openBox<TaskModel>(boxName);
    await box.clear();
    for (var task in tasks) {
      await box.put(task.id, task);
    }
  }

  Future<List<TaskModel>> getCachedTasks() async {
    final box = await Hive.openBox<TaskModel>(boxName);
    return box.values.toList();
  }
}

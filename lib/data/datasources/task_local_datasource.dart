import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskLocalDatasource {
  final Box<TaskModel> box;

  TaskLocalDatasource(this.box);

  List<TaskModel> getAllTasks() {
    return box.values.toList();
  }

  Future<void> addTask(TaskModel task) async {
    await box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    await box.put(task.id, task); // ✅ Always works — create or update
  }

  Future<void> deleteTask(String id) async {
    await box.delete(id);
  }
}

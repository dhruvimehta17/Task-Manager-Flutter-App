import '../models/task_model.dart';
import '../datasources/task_local_datasource.dart';
import '../datasources/task_api_service.dart';

class TaskRepository {
  final TaskLocalDatasource localDatasource;
  final TaskApiService? remoteDatasource;
  final bool useApi;

  TaskRepository({
    required this.localDatasource,
    this.remoteDatasource,
    this.useApi = false,
  });

  Future<List<TaskModel>> getTasks() async {
    if (useApi && remoteDatasource != null) {
      return await remoteDatasource!.getTasks();
    } else {
      return Future.value(localDatasource.getAllTasks());
    }
  }

  Future<void> addTask(TaskModel task) async {
    if (useApi && remoteDatasource != null) {
      await remoteDatasource!.addTask(task);
    } else {
      await localDatasource.addTask(task);
    }
  }

  Future<void> updateTask(TaskModel task) async {
    if (useApi && remoteDatasource != null) {
      await remoteDatasource!.updateTask(task);
    } else {
      await localDatasource.updateTask(task);
    }
  }

  Future<void> deleteTask(String id) async {
    if (useApi && remoteDatasource != null) {
      await remoteDatasource!.deleteTask(id);
    } else {
      await localDatasource.deleteTask(id);
    }
  }
}

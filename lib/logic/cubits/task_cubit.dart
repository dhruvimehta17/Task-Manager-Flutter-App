import 'package:bloc/bloc.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository repository;

  TaskCubit(this.repository) : super(TaskInitial()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      final tasks = await repository.getTasks(); // ✅ await added
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await repository.addTask(task);
      await loadTasks();
    } catch (e) {
      emit(TaskError('Failed to add task'));
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await repository.updateTask(task);
      await loadTasks();
    } catch (e) {
      emit(TaskError('Failed to update task'));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await repository.deleteTask(id);
      await loadTasks();
    } catch (e) {
      emit(TaskError('Failed to delete task'));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/task_model.dart';
import 'data/datasources/task_local_datasource.dart';
import 'data/datasources/task_api_service.dart';
import 'data/repositories/task_repository.dart';
import 'logic/cubits/task_cubit.dart';
import 'presentation/screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive Adapter
  Hive.registerAdapter(TaskModelAdapter());

  // Open Hive Box
  final box = await Hive.openBox<TaskModel>('tasks');
  final localData = TaskLocalDatasource(box);

  // Replace this with your actual API URL (e.g., from crudcrud.com)
  const apiUrl = 'https://crudcrud.com/api/YOUR_API_KEY_HERE';
  final apiService = TaskApiService(apiUrl);

  // Use API = true to switch to remote REST API
  final repo = TaskRepository(
    localDatasource: localData,
    remoteDatasource: apiService,
    useApi: true, // ✅ Toggle between API and Hive
  );

  runApp(
    BlocProvider(
      create: (_) => TaskCubit(repo),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const TaskListScreen(),
    );
  }
}

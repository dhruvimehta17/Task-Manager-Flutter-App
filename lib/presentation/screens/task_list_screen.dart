import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/task_model.dart';
import '../../logic/cubits/task_cubit.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _status = 'Pending';
  int _priority = 1;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _status = widget.task?.status ?? 'Pending';
    _priority = widget.task?.priority ?? 1;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.task != null;
      final task = TaskModel(
        id: isEditing ? widget.task!.id : const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _status,
        createdDate: isEditing ? widget.task!.createdDate : DateTime.now(),
        priority: _priority,
        remoteId: widget.task?.remoteId,
      );

      final cubit = context.read<TaskCubit>();
      if (isEditing) {
        cubit.updateTask(task);
      } else {
        cubit.addTask(task);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? 'Task updated' : 'Task added')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final themeColor = Colors.indigo;

    InputDecoration styledField(String label, String emoji) {
      return InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        leading: IconButton(
          icon: const Text('🔙', style: TextStyle(fontSize: 20)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: styledField('Title', '📝'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: styledField('Description', '📄'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: styledField('Status', '📌'),
                icon: const Text('⬇️', style: TextStyle(fontSize: 18)),
                items: ['Pending', 'In Progress', 'Done']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: styledField('Priority', '⚡'),
                icon: const Text('⬇️', style: TextStyle(fontSize: 18)),
                items: [1, 2, 3, 4, 5]
                    .map((priority) =>
                        DropdownMenuItem(value: priority, child: Text('Priority $priority')))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Update Task' : 'Add Task',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// ✅ TASK LIST SCREEN WITH DELETE CONFIRMATION
// -------------------------------------------------------------------

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Pending':
      default:
        return Colors.red;
    }
  }

  Future<void> _confirmDelete(BuildContext context, String taskId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<TaskCubit>().deleteTask(taskId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          final tasks = [...state.tasks]..sort((a, b) => a.priority.compareTo(b.priority));
          final themeColor = Colors.indigo;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeColor,
              foregroundColor: Colors.white,
              title: const Text('Task Manager'),
              centerTitle: true,
            ),
            body: tasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks yet. Tap ➕ to add one!",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          title: Text(
                            '${task.title} (P${task.priority})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.description),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(task.status).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  task.status,
                                  style: TextStyle(
                                    color: _getStatusColor(task.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Text('🗑️', style: TextStyle(fontSize: 20)),
                            onPressed: () => _confirmDelete(context, task.id),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskFormScreen(task: task),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskFormScreen()),
              ),
              child: const Text('➕', style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 255, 255, 255))),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

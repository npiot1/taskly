import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/task_screens/task_controller.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/providers/auth.dart';
import 'package:taskly/framework/providers/user.dart';

class CreateTaskScreen extends ConsumerWidget {
  CreateTaskScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _priorityController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskControllerProvider);
    final taskController = ref.read(taskControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Due Date (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a due date';
                    }
                    try {
                      DateTime.parse(value);
                    } catch (_) {
                      return 'Please enter a valid date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priorityController,
                  decoration: const InputDecoration(
                    labelText: 'Priority (1-5)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a priority';
                    }
                    final priority = int.tryParse(value);
                    if (priority == null || priority < 1 || priority > 5) {
                      return 'Priority must be between 1 and 5';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    
                    if (_formKey.currentState!.validate()) {
                      var currentUser = ref.read(authStateProvider).value;
                      final newTask = Task(
                        completed: false,
                        description: _descriptionController.text,
                        dueDate: DateTime.parse(_dueDateController.text),
                        name: _titleController.text,
                        priority: int.parse(_priorityController.text),
                        userId: currentUser!.uid, // Replace with actual user ID
                      );

                      await taskController.createTask(newTask);


                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task created successfully!'),
                        ),
                      );

                      context.push("/home");
                    }
                  },
                  child:
                      taskState is TaskLoading
                          ? CircularProgressIndicator()
                          : const Text('Create Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

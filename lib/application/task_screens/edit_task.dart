import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/task_screens/task_controller.dart';
import 'package:taskly/framework/business/task_state.dart';

class EditTaskScreen extends ConsumerWidget {
  final String id;

  const EditTaskScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(
      taskControllerProvider.select((state) => state.task),
    );
    final fetchState = ref.watch(
      taskControllerProvider.select((state) => state.state),
    );
    final taskController = ref.read(taskControllerProvider.notifier);

    if (taskState == null || fetchState is TaskLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Task')),
        body: const Center(child: CircularProgressIndicator()),
      );
    } else if (fetchState is TaskError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${fetchState.message}")));
      });
      context.pop();
      taskController.resetEditableTask();
    }

    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(
      text: taskState.name,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: taskState.description,
    );
    final TextEditingController priorityController = TextEditingController(
      text: taskState.priority.toString(),
    );
    final TextEditingController dueDateController = TextEditingController(
      text: taskState.dueDate.toIso8601String(),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
            taskController.resetEditableTask();
          },
        ),
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priorityController,
                decoration: const InputDecoration(labelText: 'Priority'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid priority';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Due Date (yyyy-MM-dd HH:mm:ss)',
                ),
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  // Pick date
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: taskState.dueDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    // Pick time
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(taskState.dueDate),
                    );
                    if (selectedTime != null) {
                      final combinedDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      dueDateController.text =
                          combinedDateTime.toIso8601String();
                      taskController.setDueDate(combinedDateTime);
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Completed'),
                value: taskState.completed,
                onChanged: (value) {
                  taskController.setEditCompleted(value);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedTask = taskState.copyWith(
                      name: nameController.text,
                      description: descriptionController.text,
                      priority: int.parse(priorityController.text),
                    );
                    taskController.updateTask(updatedTask);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task updated successfully'),
                      ),
                    );
                    context.pop();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

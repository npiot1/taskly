import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/task_screens/task_controller.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/providers/auth.dart';
import 'package:taskly/framework/utils/ui_helpers.dart';
import 'package:taskly/framework/widgets/button.dart';

class CreateTaskScreen extends ConsumerWidget {
  CreateTaskScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _priorityController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(
      taskControllerProvider.select((state) => state.state),
    );
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
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dueDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Due Date & Time (YYYY-MM-DD HH:MM:SS)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        final dt = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _dueDateController.text = dt.toString().substring(
                          0,
                          19,
                        ); // "YYYY-MM-DD HH:MM:SS"
                      }
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a due date and time';
                    }
                    try {
                      DateTime.parse(value);
                    } catch (_) {
                      return 'Please enter a valid date and time';
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
                const SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                child: AppButton(
                                                color: ApplicationColors.MAIN_COLOR,
                                                colorText: ApplicationColors.WHITE,
                                              text: 'Save Changes',
                                              buttonState: taskState,
                                              action: () async {
                                                    if (_formKey.currentState!.validate()) {
                                                      var currentUser = ref.read(authStateProvider).value;
                                                      final newTask = Task(
                                                        completed: false,
                                                        description: formatDescription(
                                                          _descriptionController.text,
                                                        ),
                                                        dueDate: DateTime.parse(_dueDateController.text),
                                                        name: _titleController.text,
                                                        priority: int.parse(_priorityController.text),
                                                        userId: currentUser!.uid, 
                                                      );
                                
                                                      await taskController.createTask(newTask);
                                
                                                      context.push("/home");
                                                    }
                                              }, 
                                              ),
                              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

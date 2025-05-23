import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/task_screens/task_controller.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/constants/app_style.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/providers/user.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(currentUserTasksProvider);
    final taskState = ref.watch(
      taskControllerProvider.select((state) => state.state),
    );

    if (taskState is TaskLoading) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    } else if (taskState is TaskError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${taskState.message}")),
        );
      });
    }

    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return Expanded(child: const Center(child: Text("No tasks found", style: TextStyle(fontSize: AppFontSize.XXLARGE_TEXT))));
        }
        tasks.sort((a, b) {
          if (a.completed != b.completed) {
            return a.completed ? 1 : -1;
          }
          return b.priority.compareTo(a.priority);
        });
        return Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final Task task = tasks[index];
              return Dismissible(
                key: Key(task.id ?? index.toString()),
                direction:
                    DismissDirection.startToEnd, 
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  final bool? confirm = await showDialog(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text("Delete this task?"),
                          content: const Text("This action cannot be undone."),
                          actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text("Delete"),
                          ),
                          ],
                        ),
                  );
                  return confirm ?? false;
                },
                onDismissed: (direction) {
                  ref
                      .read(taskControllerProvider.notifier)
                      .deleteTask(task.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("task deleted : ${task.name}")),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        ref
                            .read(taskControllerProvider.notifier)
                            .updateCompleted(task);
                      },
                      child: Icon(
                        task.completed
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: task.completed ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(
                      task.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: task.completed ? Colors.grey : Colors.black,
                        decoration:
                            task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.push('/edit/${task.id}');
                      ref
                          .read(taskControllerProvider.notifier)
                          .getTaskById(task.id!);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => Expanded(child: const Center(child: CircularProgressIndicator())),
      error: (err, _) => Center(child: Text("Erreur : $err")),
    );
  }
}

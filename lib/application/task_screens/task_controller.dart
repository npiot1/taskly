import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/repositories/user_repository.dart';

final editableTaskProvider = StateProvider.autoDispose<Task?>((ref) => null);

final taskControllerProvider = StateNotifierProvider<TaskController, TaskState>(
  (ref) {
    final userRepo = ref.read(userRepositoryProvider);
    return TaskController(userRepo, ref);
  },
);

class TaskController extends StateNotifier<TaskState> {
  final UserRepository userRepository;
  final Ref ref;

  TaskController(this.userRepository, this.ref) : super(const TaskState.idle());

  Future<void> createTask(Task task) async {
    state = const TaskState.loading();
    final result = await userRepository.createTask(task);

    if (result.isFailure) {
      state = TaskState.error(result.errorMessage!);
      return;
    } else {
      state = const TaskState.success();
    }
  }

  Future<void> updateTask(Task task) async {
    state = const TaskState.loading();
    final result = await userRepository.updateTask(task);

    if (result.isFailure) {
      state = TaskState.error(result.errorMessage!);
      return;
    } else {
      resetEditableTask();
      state = const TaskState.success();
    }
  }

  void reset() => state = const TaskState.idle();

  void resetEditableTask() {
    ref.read(editableTaskProvider.notifier).state = null;
  }

  void setCompleted(bool value) {
    ref.read(editableTaskProvider.notifier).state = ref
        .read(editableTaskProvider.notifier)
        .state!
        .copyWith(completed: value);
  }

  void setEditableTask(Task taskFromFirestore) {
    ref.read(editableTaskProvider.notifier).state = taskFromFirestore;
  }

  void setDueDate(DateTime combinedDateTime) {
    ref.read(editableTaskProvider.notifier).state = ref
        .read(editableTaskProvider.notifier)
        .state!
        .copyWith(dueDate: combinedDateTime);
  }

}

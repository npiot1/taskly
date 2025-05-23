import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/application/task_screens/task_screen_state.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/repositories/user_repository.dart';

//final editableTaskProvider = StateProvider.autoDispose<Task?>((ref) => null);

final taskControllerProvider = StateNotifierProvider<TaskController, TaskScreenState>(
  (ref) {
    final userRepo = ref.read(userRepositoryProvider);
    return TaskController(userRepo, ref);
  },
);

class TaskController extends StateNotifier<TaskScreenState> {
  final UserRepository userRepository;
  final Ref ref;

  TaskController(this.userRepository, this.ref) : super(TaskScreenState());

  Future<void> createTask(Task task) async {
    state = state.copyWith(state: const TaskState.loading());
    final result = await userRepository.createTask(task);

    if (result.isFailure) {
      state = state.copyWith(state: TaskState.error(result.errorMessage!));
      return;
    } else {
      state = state.copyWith(state: const TaskState.success());
    }
  }

  Future<void> updateTask(Task task) async {
    state = state.copyWith(state: const TaskState.loading());
    final result = await userRepository.updateTask(task);

    if (result.isFailure) {
      state = state.copyWith(state: TaskState.error(result.errorMessage!));
      return;
    } else {
      resetEditableTask();
      state = state.copyWith(state: const TaskState.success());
    }
  }

  Future<void> updateCompleted(Task task) async {
    state = state.copyWith(state: const TaskState.loading());
    task = task.copyWith(completed: !task.completed);
    final result = await userRepository.updateTask(task);
    if (result.isFailure) {
      state = state.copyWith(state: TaskState.error(result.errorMessage!));
      return;
    } else {
      state = state.copyWith(state: const TaskState.success());
    }
  }

  void reset() => state = state.copyWith(state: const TaskState.idle());

  void resetEditableTask() {
    state = state.copyWith(task: null);
  }

  void setEditCompleted(bool value) {
    state = state.copyWith(
      task: state.task?.copyWith(completed: value),
    );
  }

  void setEditableTask(Task taskFromFirestore) {
    state = state.copyWith(
      task: taskFromFirestore,
    );
  }

  void setDueDate(DateTime combinedDateTime) {
    state = state.copyWith(
      task: state.task?.copyWith(dueDate: combinedDateTime),
    );
  }

}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/application/task_screens/task_screen_state.dart';
import 'package:taskly/framework/business/result.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/repositories/user_repository.dart';

//final editableTaskProvider = StateProvider.autoDispose<Task?>((ref) => null);

final taskControllerProvider = StateNotifierProvider.autoDispose<TaskController, TaskScreenState>(
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
    result.showNotification();

    if (result.isFailure) {
      state = state.copyWith(state: TaskState.error(result.errorMessage!));
      return;
    } else {
      state = state.copyWith(state: const TaskState.success());
    }
  }

  Future<void> load() async {
    state = state.copyWith(state: const TaskState.loading());
  }

  Future<void> success() async {
    state = state.copyWith(state: const TaskState.success());
  }

  Future<void> updateTask(Task task) async {
    state = state.copyWith(state: const TaskState.loading());
    final result = await userRepository.updateTask(task);
    result.showNotification();

    if (result.isFailure) {
      state = state.copyWith(state: TaskState.error(result.errorMessage!));
      return;
    } else {
      resetEditableTask();
      state = state.copyWith(state: const TaskState.success());
    }
  }

  Future<void> deleteTask(String taskId) async {
    state = state.copyWith(state: const TaskState.loading());
    final result = await userRepository.deleteTask(taskId);
    result.showNotification();

    if (result.isFailure) {
      state = state.copyWith(state: TaskState.error(result.errorMessage!));
      return;
    } else {
      state = state.copyWith(state: const TaskState.success());
    }
  }

  Future<Task?> getTaskById(String id) async {
    state = state.copyWith(state: const TaskState.loading());
    final result = await userRepository.getTaskById(id);
    if (result.isFailure) {
      state = state.copyWith(state: TaskState.error(result.errorMessage!));
      return null;
    } else {
      state = state.copyWith(
        task: result.data,
        state: const TaskState.success(),
      );
      return result.data!;
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/repositories/user_repository.dart';

final taskControllerProvider =
    StateNotifierProvider<TaskController, TaskState>((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  return TaskController(userRepo);
});

class TaskController extends StateNotifier<TaskState> {
  final UserRepository userRepository;

  TaskController(this.userRepository) : super(const TaskState.idle());

  Future<void> createTask(Task task) async {
    state = const TaskState.loading();
    final result = await userRepository.createTask(task);

    if(result.isFailure) {
      state = TaskState.error(result.errorMessage!);
      return;
    } else {
      state = const TaskState.success();
    }
  }

  void reset() => state = const TaskState.idle();
}

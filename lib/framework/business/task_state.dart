import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_state.freezed.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState.idle() = TaskIdle;
  const factory TaskState.loading() = TaskLoading;
  const factory TaskState.success() = TaskSuccess;
  const factory TaskState.error(String message) = TaskError;
}

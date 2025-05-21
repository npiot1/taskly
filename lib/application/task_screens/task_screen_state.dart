import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/models/task.dart';

part 'task_screen_state.freezed.dart';

@freezed
abstract class TaskScreenState with _$TaskScreenState {
  const factory TaskScreenState({
    Task? task,
    @Default(TaskState.idle()) TaskState state,
  }) = _TaskScreenState;
}

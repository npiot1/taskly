import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskly/framework/models/app_user.dart';
import 'package:taskly/framework/business/task_state.dart';

part 'account_screen_state.freezed.dart';

@freezed
abstract class AccountScreenState with _$AccountScreenState {
  const factory AccountScreenState({
    required AppUser user,
    required String email,
    @Default('') String newPassword,
    @Default(TaskState.idle())  TaskState state,
  }) = _AccountScreenState;
}

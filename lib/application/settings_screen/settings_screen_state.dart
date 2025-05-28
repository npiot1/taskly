import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_screen_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(false) bool isDarkMode,
    @Default(false) bool hideCompletedTasks,
  }) = _SettingsState;
}
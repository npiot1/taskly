import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:taskly/application/settings_screen/settings_screen_state.dart';

final settingsProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController();
});


class SettingsController extends StateNotifier<SettingsState> {
  static const boxName = 'settings';

  late Box box;

  SettingsController()
      : super(SettingsState(isDarkMode: false, hideCompletedTasks: false)) {
    _loadSettings();
  }

  static Future<void> initBox() async {
    final box = await Hive.openBox(boxName);
    if (!box.containsKey('isDarkMode')) {
      box.put('isDarkMode', false);
    }
    if (!box.containsKey('hideCompletedTasks')) {
      box.put('hideCompletedTasks', false);
    }
  }

  Future<void> _loadSettings() async {
    box = await Hive.openBox(boxName);
    state = SettingsState(
      isDarkMode: box.get('isDarkMode', defaultValue: false),
      hideCompletedTasks: box.get('hideCompletedTasks', defaultValue: false),
    );
  }

  void toggleDarkMode(bool value) {
    state = state.copyWith(isDarkMode: value);
    box.put('isDarkMode', value);
  }

  void toggleHideCompleted(bool value) {
    state = state.copyWith(hideCompletedTasks: value);
    box.put('hideCompletedTasks', value);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/application/settings_screen/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsController = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: settings.isDarkMode,
            onChanged: settingsController.toggleDarkMode,
          ),
          SwitchListTile(
            title: Text('Hide Completed Tasks'),
            value: settings.hideCompletedTasks,
            onChanged: settingsController.toggleHideCompleted,
          ),
        ],
      ),
    );
  }
}

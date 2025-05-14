import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/application/home_screen/drawer.dart';
import 'package:taskly/application/home_screen/tasks.dart';
import 'package:taskly/framework/constants/app_utils.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: DrawerWidget(),
      backgroundColor: ApplicationColors.WHITE,
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: Column(
          children: [
            Text('Welcome to the Home Screen!'),
            TaskListScreen(),
            Spacer(),
            Text("bottom"),
          ],
        ),
      ),
    );
  }
}

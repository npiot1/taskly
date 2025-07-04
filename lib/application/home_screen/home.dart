import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/home_screen/drawer.dart';
import 'package:taskly/application/task_screens/tasks.dart';
import 'package:taskly/framework/constants/app_utils.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: Column(
          children: [
            TaskListScreen(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: ElevatedButton(
              onPressed: () {
                context.push('/new');
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(16),
                backgroundColor: ApplicationColors.MAIN_COLOR, 
              ),
                child: Icon(Icons.add, color: Colors.white),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

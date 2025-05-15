import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/application/home_screen/drawer.dart';
import 'package:taskly/application/task_screens/tasks.dart';
import 'package:taskly/framework/constants/app_style.dart';
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tasks',
                style: TextStyle(fontSize: AppFontSize.XXLARGE_TEXT),
              ),
            ),
            TaskListScreen(),
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: ElevatedButton(
              onPressed: () {},
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

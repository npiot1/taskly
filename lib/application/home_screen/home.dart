import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/application/home_screen/tasks.dart';
import 'package:taskly/framework/auth/firebase_providers.dart';
import 'package:taskly/framework/constants/app_utils.dart';
import 'package:taskly/framework/widgets/button.dart';
import 'package:taskly/main.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
      return Scaffold(
          appBar: AppBar(
                title: Text('Home Screen'),
            ),
            body: Center(
                child: Column(
                  children: [
                    Text('Welcome to the Home Screen!'),
                    TaskListScreen(),
                    Spacer(),
                    AppButton(color: ApplicationColors.ORANGE, text: "Logout", action: () {
                      var auth = ref.read(authRepositoryProvider);
                      auth.logout().then((value) {
                        scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                          SnackBar(
                            content: Text("Logout successful"),
                          ),
                        );
                      }).catchError((error) {
                        scaffoldMessengerKey.currentState
                                      ?.showSnackBar(
                          SnackBar(
                            content: Text("Logout failed: $error"),
                          ),
                        );
                      });
                    }),
                  ],
                ),
          
            ),
        );
  }
}
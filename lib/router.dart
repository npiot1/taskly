import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/account_screen/account.dart';
import 'package:taskly/application/home_screen/home.dart';
import 'package:taskly/application/login_screen/login.dart';
import 'package:taskly/application/login_screen/signup.dart';
import 'package:taskly/application/settings_screen/settings.dart';
import 'package:taskly/application/task_screens/create_task.dart';
import 'package:taskly/application/task_screens/edit_task.dart';
import 'package:taskly/framework/providers/auth.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          final authState = ref.watch(authStateProvider);

          return authState.when(
            data: (user) {
              if (user == null) {
                return LoginScreen();
              } else {
                return const HomeScreen();
              }
            },
            loading:
                () => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
            error: (e, _) => Scaffold(body: Center(child: Text('Erreur: $e'))),
          );
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => SignUpScreen()),
      GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/new', builder: (context, state) => CreateTaskScreen()),
      GoRoute(
        path: '/edit/:id',
        name: 'edit',
        builder: (context, state) {
          final taskId = state.pathParameters['id']!;
          return EditTaskScreen(id: taskId);
        },
      ),
      GoRoute(path: '/settings', builder: (context, state) => SettingsScreen()),
      GoRoute(path: '/account', builder: (context, state) => AccountScreen()),
    ],
  );
});

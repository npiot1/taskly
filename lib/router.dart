import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/home_screen/home.dart';
import 'package:taskly/application/login_screen/login.dart';
import 'package:taskly/application/login_screen/signup.dart';
import 'package:taskly/framework/auth/auth_provider.dart';

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
                return LoginScreen(); // non connecté
              } else {
                return const HomeScreen(); // connecté
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
    ],
  );
});

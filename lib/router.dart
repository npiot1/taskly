import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskly/application/login_screen/login.dart';
import 'package:taskly/framework/auth/auth_gate.dart';

final routerProvider = Provider<GoRouter>((ref) {

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const AuthGate();
        },
      ),
      // Tu peux aussi avoir d'autres routes, ex:
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
    ],
  );
});

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final authStateProvider = StreamProvider<User?>((ref) {
    return FirebaseAuth.instance.authStateChanges();
  });

  final currentAuthUserProvider = Provider<User?>((ref) {
    final authState = ref.watch(authStateProvider);
    return authState.asData?.value;
  });

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/data/repository/auth_repository.dart';
import 'package:taskly/framework/models/app_user.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final appUserProvider = FutureProvider<AppUser>((ref) async {
  final firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception("User not logged in");
  }

  final doc = await firestore.collection('users').doc(currentUser.uid).get();

  if (!doc.exists) {
    throw Exception("User profile not found");
  }

  return AppUser.fromJson(doc.data()!);
});

final userTasksProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final userAsync = ref.watch(authStateProvider);

  return userAsync.when(
    data: (user) {
      if (user == null) return const Stream.empty();

      final db = ref.watch(firestoreProvider);
      final query = db
          .collection('tasks')
          .where('userId', isEqualTo: user.uid);

      return query.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => doc.data()).toList());
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});


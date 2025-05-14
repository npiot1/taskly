import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/models/app_user.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/providers/auth.dart';
import 'package:taskly/framework/repositories/auth_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
    return UserRepository(FirebaseFirestore.instance, ref);
  });

  class UserRepository {

  final FirebaseFirestore _firestore;
  final Ref ref;
  UserRepository(this._firestore, this.ref);

  Future<AppUser> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) {
      throw Exception("User profile not found");
    }

    return AppUser.fromJson(doc.data()!); 
    }

  Future<AppUser> getCurrentUser() async {

    User? currentUser = await ref.read(authRepositoryProvider).getCurrentUser();
    if (currentUser == null) {
      throw Exception("User not logged in");
    }
    return await getUserProfile(currentUser.uid);
    
    }

    Stream<List<Task>> getUserTasks() {
      final userAsync = ref.watch(authStateProvider);

      return userAsync.when(
        data: (user) {
          if (user == null) return const Stream.empty();

          final query = _firestore
              .collection('tasks')
              .where('userId', isEqualTo: user.uid);

            return query.snapshots().map((snapshot) =>
              snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList());
        },
        loading: () => const Stream.empty(),
        error: (_, __) => const Stream.empty(),
      );
    }

  }
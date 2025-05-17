import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/business/result.dart';
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

  Future<Result<bool>> createAppUser(User user, String username) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'pseudo': username,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await user.updateDisplayName(username);
      await user.reload();
      return Result.success(true);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<AppUser?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      return AppUser.fromJson(doc.data()!);
    } catch (e) {
      return null;
    }
  }

  Future<Result<AppUser?>> getCurrentUser() async {
    try {
      User? currentUser = ref.read(authRepositoryProvider).getCurrentUser();
      if (currentUser == null) {
        return Result.success(null);
      }
      final userProfile = await getUserProfile(currentUser.uid);
      if (userProfile == null) {
        return Result.failure("User profile not found");
      }
      return Result.success(userProfile);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Stream<List<Task>> getUserTasks() {
    final userAsync = ref.read(authStateProvider);

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
      error: (error, _) => Stream.error(error.toString()),
    );
  }

  Future<Result<bool>> createTask(Task task) async {
    try {
      await _firestore.collection('tasks').add(task.toJson());
      return Result.success(true);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  }
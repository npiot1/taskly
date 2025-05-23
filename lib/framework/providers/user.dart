import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/models/app_user.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/providers/auth.dart';
import 'package:taskly/framework/repositories/user_repository.dart';

final currentAppUserProvider = StreamProvider<AppUser?>((ref) {
  final firebaseUser = ref.watch(authStateProvider);

  return firebaseUser.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(userRepositoryProvider).watchAppUser(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final currentUserTasksProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final currentUser = ref.watch(currentAppUserProvider);
  if (currentUser.isLoading) {
    return const Stream.empty();
  }
  if (currentUser.hasError) {
    return const Stream.empty(); 
  }
  final userRepo = ref.read(userRepositoryProvider);
  return userRepo.getUserTasks();
});


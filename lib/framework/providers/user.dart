import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/models/app_user.dart';
import 'package:taskly/framework/models/task.dart';
import 'package:taskly/framework/providers/auth.dart';
import 'package:taskly/framework/repositories/user_repository.dart';

final currentUserProvider = FutureProvider<AppUser>((ref) async {
  final authUser = await ref.watch(authStateProvider.future);
  if (authUser == null) {
    throw Exception("No user logged in");
  }
  final userRepo = ref.read(userRepositoryProvider);
  final userProfile = await userRepo.getUserProfile(authUser.uid);
  if (userProfile == null) {
    throw Exception("User profile not found");
  }
  return userProfile;
});

final currentUserTasksProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser.isLoading) {
    return const Stream.empty();
  }
  if (currentUser.hasError) {
    return const Stream.empty(); 
  }
  final userRepo = ref.read(userRepositoryProvider);
  return userRepo.getUserTasks();
});

final currentUserTaskByIdProvider = StreamProvider.autoDispose.family<Task?, String>((ref, taskId) {
  final tasksAsync = ref.watch(currentUserTasksProvider);
  if (tasksAsync.isLoading) {
    return const Stream.empty();
  }
  if (tasksAsync.hasError) {
    return const Stream.empty();
  }
  final tasks = tasksAsync.value ?? [];
  return Stream.value(
    tasks.firstWhere(
      (task) => task.id == taskId,
      orElse: () => throw Exception('Task not found'),
    ),
  );
});


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/business/result.dart';
import 'package:taskly/framework/business/task_state.dart';
import 'package:taskly/framework/providers/auth.dart';
import 'package:taskly/framework/providers/user.dart';
import 'package:taskly/application/account_screen/account_screen_state.dart';
import 'package:taskly/framework/repositories/auth_repository.dart';
import 'package:taskly/framework/repositories/user_repository.dart';

final accountControllerProvider = StateNotifierProvider.autoDispose<AccountController, AccountScreenState>(
  (ref) => AccountController(ref),
);

class AccountController extends StateNotifier<AccountScreenState> {
  final Ref ref;

  AccountController(this.ref) : super(AccountScreenState(
    user: ref.read(currentAppUserProvider).value!,
    email: ref.read(currentAuthUserProvider)!.email!,
  ));

  initState() {
    state = AccountScreenState(
      user: ref.read(currentAppUserProvider).value!,
      email: ref.read(currentAuthUserProvider)!.email!,
    );
  }

  Future<Result> updateEmail() async {
    state = state.copyWith(state: const TaskState.loading());
    try {
      var res = await ref.read(authRepositoryProvider).updateEmail(state.email);
      state = state.copyWith(state: const TaskState.success());
      return res;
    } catch (e) {
      state = state.copyWith(state: TaskState.error(e.toString()));
      return Result.failure(e.toString());
    }
  }

  Future<Result> updatePassword() async {
    state = state.copyWith(state: const TaskState.loading());
    try {
      var res = await ref.read(authRepositoryProvider).updatePassword(state.newPassword);
      state = state.copyWith(state: const TaskState.success());
      return res;
    } catch (e) {
      state = state.copyWith(state: TaskState.error(e.toString()));
      return Result.failure(e.toString());
    }
  }

  Future<Result> updateUser() async {
    state = state.copyWith(state: const TaskState.loading());
    try {
      var res = await ref.read(userRepositoryProvider).updateUser(state.user);
      state = state.copyWith(state: const TaskState.success());
      return res;
    } catch (e) {
      state = state.copyWith(state: TaskState.error(e.toString()));
      return Result.failure(e.toString());
    }
  }

  void updatePseudo(String newPseudo) {
    state = state.copyWith(user: state.user.copyWith(pseudo: newPseudo));
  }

  void updatePhotoUrl(String newPhotoUrl) {
    if (newPhotoUrl.isEmpty) {
      state = state.copyWith(user: state.user.copyWith(photoUrl: null));
    } else { 
      state = state.copyWith(user: state.user.copyWith(photoUrl: newPhotoUrl)); 
    }
  }

  void updateEmailState(String newEmail) {
    state = state.copyWith(email: newEmail);
  }

    void updatePasswordState(String newPassword) {
    state = state.copyWith(
      newPassword: newPassword,
    );
  }

  Future<Result> reAuthenticate(String password) async {
    state = state.copyWith(state: const TaskState.loading());
    try {
      var res = await ref.read(authRepositoryProvider).reAuthenticate(password);
      state = state.copyWith(state: const TaskState.success());
      return res;
    } catch (e) {
      state = state.copyWith(state: TaskState.error(e.toString()));
      return Result.failure(e.toString());
    }
  }


}

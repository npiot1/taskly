import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskly/framework/business/result.dart';
import 'package:taskly/framework/repositories/user_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance, ref);
});

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final Ref ref;
  AuthRepository(this._firebaseAuth, this.ref);

  Future<Result> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        var res = await ref
            .read(userRepositoryProvider)
            .createAppUser(user, username);
        if (res.isSuccess) {
          return Result.success(null, "Account created successfully!");
        } else {
          return Result.failure(res.errorMessage!);
        }
      }
      return Result.failure("Error creating account");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Result.failure('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return Result.failure('The account already exists for that email.');
      }
      return Result.failure("Error creating account (${e.code})");
    } catch (e) {
      return Result.failure("Error creating account (${e.toString()})");
    }
  }

  Future<Result> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result.success(null, "Connected!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Result.failure('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return Result.failure('Wrong password provided for that user.');
      }
      return Result.failure("Error logging in (${e.code})");
    }
  }

  Future<Result> reAuthenticate(String password) async {
    
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return Result.failure("No user is currently logged in.");
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return Result.success(null, "Reauthentication successful!");
    } catch (e) {
      return Result.failure("Error reauthenticating (${e.toString()})");
    }

  }

  Future<Result> logout() async {
    try {
      await _firebaseAuth.signOut();
      return Result.success(null, "Logged out successfully!");
    } catch (e) {
      return Result.failure("Error logging out (${e.toString()})");
    }
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;

  Future<Result> updateEmail(String email) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return Result.failure("No user is currently logged in.");
    }
    try {
      await user.verifyBeforeUpdateEmail(email);
      await user.reload();
      return Result.success(null, "Email updated successfully!");
    } catch (e) {
      return Result.failure("Error updating email (${e.toString()})");
    }
  }

  Future<Result> updatePassword(String password) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return Result.failure("No user is currently logged in.");
    }
    try {
      await user.updatePassword(password);
      await user.reload();
      return Result.success(null, "Password updated successfully!");
    } catch (e) {
      return Result.failure("Error updating password (${e.toString()})");
    }
  }
}

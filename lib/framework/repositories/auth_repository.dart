import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

  final authRepositoryProvider = Provider<AuthRepository>((ref) {
    return AuthRepository(FirebaseAuth.instance);
  });

class AuthRepository {

  final FirebaseAuth _firebaseAuth;
  AuthRepository(this._firebaseAuth);

  Future<String> signUp({
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

      ////

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'pseudo': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        await user.updateDisplayName(username);
        await user.reload();
      }

      /////

      return "Account successfully created!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return "Error creating account (${e.code})";
    } catch (e) {
      return "Error creating account (${e.toString()})";
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Connected!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return "Error logging in (${e.code})";
    }
  }

  Future<void> logout() => _firebaseAuth.signOut();

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }
}

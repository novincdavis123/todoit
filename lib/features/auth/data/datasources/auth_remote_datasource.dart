import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoit/core/error/app_exceptions.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final fb.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource({required this.firebaseAuth, required this.firestore});

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      return UserModel.fromFirestore(doc);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userModel = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
      );
      await firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toFirestore());
      return userModel;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    }
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) return null;
    final doc = await firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromFirestore(doc);
  }

  String _mapFirebaseError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already registered.';
      default:
        return 'Authentication failed.';
    }
  }
}

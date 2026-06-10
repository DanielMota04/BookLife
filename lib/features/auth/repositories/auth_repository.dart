import 'package:book_life/core/errors/auth_errors.dart';
import 'package:book_life/features/auth/models/login_user_model.dart';
import 'package:book_life/features/auth/models/register_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Future<void> registerUser(RegisterUserModel data) async {
    final userCredentials = await _auth.createUserWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );

    await _firestore.collection('users').doc(userCredentials.user!.uid).set({
      'nome': data.name,
      'email': data.email,
      'createdAt': DateTime.now(),
    });
  }

  Future<void> loginUser(LoginUserModel data) async {
    await _auth.signInWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw UserNotLoggedInException();
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          throw WrongPasswordException();
        default:
          throw UnknownAuthException(e.code);
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

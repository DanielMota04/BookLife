import 'package:book_life/core/errors/auth_errors.dart';
import 'package:book_life/features/auth/models/login_user_model.dart';
import 'package:book_life/features/auth/models/register_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<void> loginWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      clientId:
          '658177107812-g20th3la725fl9bb225hi2l81khgs1qv.apps.googleusercontent.com',
    );

    final user = await googleSignIn.signIn();

    if (user == null) return;
    final googleAuth = await user.authentication;
    final userCredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    try {
      final result = await _auth.signInWithCredential(userCredentials);

      if (!user.email.endsWith('@souunit.com.br')) {
        await _auth.signOut();
        await googleSignIn.signOut();
        throw UnauthorizedDomainException();
      }

      if (result.additionalUserInfo?.isNewUser == true) {
        await _firestore.collection('users').doc(result.user!.uid).set({
          'nome': user.displayName,
          'email': user.email,
          'createdAt': DateTime.now(),
        });
      }
    } on FirebaseAuthException catch (e) {
      throw UnknownAuthException(e.code);
    }
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:book_life/core/errors/auth_errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRepository(this._firestore, this._auth);

  Future<void> updateData({
    String? username,
    String? email,
    Uint8List? photoBytes,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw UserNotLoggedInException();

    try {
      if (email != null && email.isNotEmpty && email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
      }

      final data = <String, dynamic>{
        'updatedAt': DateTime.now(),
        if (username != null && username.isNotEmpty) 'nome': username,
        if (email != null && email.isNotEmpty) 'email': email,
        if (photoBytes != null) 'photoBase64': base64Encode(photoBytes),
      };

      await _firestore.collection('users').doc(user.uid).update(data);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw RequiresRecentLoginException();
      }
      throw UnknownAuthException(e.code);
    } on FirebaseException catch (e) {
      throw UnknownAuthException(e.code);
    }
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw UserNotLoggedInException();

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() ?? {};
    } on FirebaseException catch (e) {
      throw UnknownAuthException(e.code);
    }
  }
}

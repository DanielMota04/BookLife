import 'package:book_life/core/errors/auth_errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRepository(this._firestore, this._auth);

  Future<void> updateData({String? username, String? email}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw UserNotLoggedInException();

    try {
      final data = <String, dynamic>{
        'updatedAt': DateTime.now(),
        if (username != null && username.isNotEmpty) 'nome': username,
        if (email != null && email.isNotEmpty) 'email': email,
      };

      await _firestore.collection('users').doc(uid).update(data);
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

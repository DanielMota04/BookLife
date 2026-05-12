import 'package:book_life/features/auth/models/register_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

   Future<void> registerUser(RegisterUserModel data) async {

    final userCredentials = await _auth.createUserWithEmailAndPassword(email: data.email, password: data.password);

    await _firestore
    .collection('users')
    .doc(userCredentials.user!.uid)
    .set({
      'nome': data.name,
      'email': data.email,
      'createdAt': DateTime.now()
    });
   }
}
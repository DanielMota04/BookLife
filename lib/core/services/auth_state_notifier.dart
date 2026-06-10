import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier(FirebaseAuth auth) {
    auth.authStateChanges().listen((_) => notifyListeners());
  }
}
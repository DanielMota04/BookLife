import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComunidadeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> get feedStream {
    return _firestore
        .collection('feed')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Função para testar ou registrar atividades reais
  Future<void> publicarAtividade({
    required String userId,
    required String userName,
    required String action,
    required String bookTitle,
    String? review,
    int rating = 0,
    bool isSpoiler = false,
  }) async {
    await _firestore.collection('feed').add({
      'userId': userId,
      'userName': userName,
      'action': action,
      'bookTitle': bookTitle,
      'review': review ?? '',
      'rating': rating,
      'isSpoiler': isSpoiler,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

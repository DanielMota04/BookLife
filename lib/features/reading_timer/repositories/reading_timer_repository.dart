import 'package:book_life/features/reading_timer/models/lapModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadingTimerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'books';

  Future<void> saveLap(String bookId, LapModel lap) async {
    try {
      if (bookId.isEmpty) throw Exception('ID do livro inválido.');

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Usuário não autenticado.');

      final mapData = lap.toMap();
      mapData['userId'] = userId;

      await _firestore
          .collection(_collection)
          .doc(bookId)
          .collection('laps')
          .add(mapData);
    } catch (e) {
      throw Exception('Falha ao salvar o tempo de leitura: $e');
    }
  }

  Future<void> removeLap(String bookId, String lapId) async {
    try {
      if (bookId.isEmpty) throw Exception('ID do livro inválido.');

      await _firestore
          .collection(_collection)
          .doc(bookId)
          .collection('laps')
          .doc(lapId)
          .delete();
    } catch (e) {
      throw Exception('Falha ao remover o tempo de leitura: $e');
    }
  }

  Future<List<LapModel>> getAllLaps(String bookId) async {
    try {
      if (bookId.isEmpty) throw Exception('ID do livro inválido.');

      final snapshot = await _firestore
          .collection(_collection)
          .doc(bookId)
          .collection('laps')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return LapModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      if (book.id == null || book.id!.isEmpty) {
        throw Exception('ID do livro inválido.');
      }

      await _firestore
          .collection(_collection)
          .doc(book.id)
          .update(book.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar livro: $e');
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_life/core/models/book_model.dart';

class BookDetailsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'books';

  Future<Book?> getBookById(String bookId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(bookId).get();
      if (doc.exists && doc.data() != null) {
        return Book.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar livro no repositório: $e');
    }
  }

  /// Atualiza os dados do livro e registra o histórico de leitura do dia atual
  Future<void> updateBookWithHistory({
    required Book book,
    required int pagesReadInThisSession,
  }) async {
    try {
      if (book.id == null || book.id!.isEmpty) {
        throw Exception('ID do livro inválido.');
      }

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('Usuário não autenticado.');

      final batch = _firestore.batch();
      final bookRef = _firestore.collection(_collection).doc(book.id);

      batch.update(bookRef, book.toMap());

      if (pagesReadInThisSession > 0) {
        final dataDeHoje = DateTime.now().toIso8601String().split('T')[0];
        final historyRef = bookRef.collection('reading_history').doc(dataDeHoje);

        batch.set(
          historyRef,
          {
            'userId': userId,
            'pagesRead': FieldValue.increment(pagesReadInThisSession),
            'date': dataDeHoje,
            'timestamp': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Erro ao registrar histórico de leitura: $e');
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      if (book.id == null || book.id!.isEmpty) {
        throw Exception('ID do livro inválido.');
      }

      await _firestore.collection(_collection).doc(book.id).update(book.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar livro: $e');
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> updateBook(Book book) async {
    try {
    if (book.id == null || book.id!.isEmpty) {
      throw Exception('Não é possível atualizar um livro sem um ID válido');
    }

    print("Atualizando livro com ID: ${book.id}");

    await _firestore
        .collection(_collection)
        .doc(book.id)
        .update(book.toMap());

  } catch (e) {
    throw Exception('Erro ao atualizar livro: $e');
  }
  }
}
import 'package:book_life/features/reading_timer/models/lapModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_life/core/models/book_model.dart';

class ReadingTimerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collection = 'books';

  Future<void> saveLap(String bookId, LapModel lap) async {
    try {
      if (bookId == null || bookId.isEmpty) {
        throw Exception('Não é possível atualizar um livro sem um ID válido');
      }
      await _firestore
          .collection('books')
          .doc(bookId)
          .collection('laps')
          .add(lap.toMap());
    } catch (e) {
      throw Exception('Falha ao salvar o lap de leitura: $e');
    }
  }
  Future<void> removeLap(String bookId, String lapId) async{
    try{
      if (bookId == null || bookId.isEmpty) {
        throw Exception('Não é possível atualizar um livro sem um ID válido');
      }
      await _firestore.collection(_collection).doc(bookId).collection('laps').doc(lapId).delete();
      
    }catch (e){
      throw Exception('Falha ao salvar o lap de leitura: $e');
    }
  }
  Future<List<LapModel>> getAllLaps(String bookId) async {
    try {
      if (bookId == null || bookId.isEmpty) {
        throw Exception('Não é possível atualizar um livro sem um ID válido');
      }
      QuerySnapshot snapshot = await _firestore.collection(_collection).doc(bookId).collection('laps').get();
      final List<LapModel> allLaps = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return LapModel.fromMap(data,doc.id);
      }).toList();    
      return allLaps;
    } catch (e) {
      return [];
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      if (book.id == null || book.id!.isEmpty) {
        throw Exception('Não é possível atualizar um livro sem um ID válido');
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

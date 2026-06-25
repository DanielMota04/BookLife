import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_life/core/models/progresso_model.dart';
import 'package:book_life/core/models/book_model.dart';

class ProgressoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> buscarDadosDoUsuario(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }

  Future<List<Book>> buscarLivros(String userId) async {
    final snapshot = await _firestore.collection('books').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => Book.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<HistoricoModel>> buscarHistoricoDeLeitura(String userId) async {
    final snapshot = await _firestore.collectionGroup('reading_history').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => HistoricoModel.fromMap(doc.data())).toList();
  }

  Future<List<TimerLapModel>> buscarLapsDoTimer(String userId) async {
    final snapshot = await _firestore.collectionGroup('laps').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => TimerLapModel.fromMap(doc.data())).toList();
  }

  Future<List<MetaModel>> buscarMetas(String userId) async {
    final snapshot = await _firestore.collection('metas').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => MetaModel.fromMap(doc.data())).toList();
  }
}
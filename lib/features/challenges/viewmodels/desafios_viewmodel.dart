import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_life/features/progress/repositories/progresso_repository.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesafiosViewModel extends ChangeNotifier {
  final ProgressoRepository _repository = ProgressoRepository();

  bool _carregando = true;
  int _metaAnual = 12; // Valor padrão
  List<Book> _livrosLidosEsteAno = [];

  bool get carregando => _carregando;
  int get metaAnual => _metaAnual;
  int get totalLidos => _livrosLidosEsteAno.length;
  List<Book> get livrosLidosEsteAno => _livrosLidosEsteAno;

  Future<void> inicializar() async {
    await carregarDadosDoDesafio();
  }

  Future<void> carregarDadosDoDesafio() async {
    _carregando = true;
    notifyListeners();

    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) {
      _carregando = false;
      notifyListeners();
      return;
    }

    final idDoUsuario = usuarioAtual.uid;
    final anoAtual = DateTime.now().year;

    try {
      // Busca a meta anual do perfil do usuário
      final docUsuario = await _repository.buscarDadosDoUsuario(idDoUsuario);
      if (docUsuario.exists && docUsuario.data() != null) {
        final dados = docUsuario.data() as Map<String, dynamic>;
        if (dados.containsKey('annualGoal')) {
          _metaAnual = (dados['annualGoal'] as num).toInt();
        }
      }

      // Busca todos os livros lidos no ano atual
      final livros = await _repository.buscarLivros(idDoUsuario);
      _livrosLidosEsteAno = livros.where((livro) {
        return livro.isCompleted && livro.addedAt.year == anoAtual;
      }).toList();

    } catch (e) {
      // Ignora erros para não quebrar a tela
    }

    _carregando = false;
    notifyListeners();
  }

  Future<void> atualizarMetaAnual(int novaMeta) async {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(usuarioAtual.uid).set(
        {'annualGoal': novaMeta}, SetOptions(merge: true)
      );
      _metaAnual = novaMeta;
      notifyListeners();
    } catch (e) {
      // Ignora erro
    }
  }
}

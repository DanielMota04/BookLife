import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_life/core/models/book_model.dart';
import 'package:book_life/features/library/repositories/book_repository.dart';
import 'package:book_life/core/enums/reading_status.dart';

class BibliotecaViewModel extends ChangeNotifier {
  final BookRepository _repository = BookRepository();

  String termoDePesquisa = '';
  String filtroAtivo = 'Todos';

  // Retorna o fluxo de livros do Firebase
  Stream<List<Book>> get streamDeLivros {
    final usuarioAtual = FirebaseAuth.instance.currentUser;
    if (usuarioAtual == null) return const Stream.empty();

    return _repository.obterLivrosDoUsuario(usuarioAtual.uid);
  }

  // Método para chamar a barra de pesquisa e atualizar o termo
  void atualizarPesquisa(String novoTermo) {
    termoDePesquisa = novoTermo.toLowerCase();
    notifyListeners();
  }

  // Método chamado quando o usuário clica em uma aba (Todos, Lendo, Lido)
  void atualizarFiltro(String novoFiltro) {
    filtroAtivo = novoFiltro;
    notifyListeners();
  }

  // Lógica para filtrar os livros na memorio
  List<Book> aplicarFiltrosNaLista(List<Book> listaOriginal) {
    return listaOriginal.where((livro) {
      final passouNaPesquisa = livro.title.toLowerCase().contains(
        termoDePesquisa,
      );

      final passouNoFiltroDeAba = filtroAtivo == 'Todos'
          ? true
          : _traduzirStatus(livro.status) == filtroAtivo;

      return passouNaPesquisa && passouNoFiltroDeAba;
    }).toList();
  }

  // Helper para traduzir o Enum do Dart para o texto das abas
  String _traduzirStatus(ReadingStatus status) {
    switch (status) {
      case ReadingStatus.reading:
        return 'Lendo';
      case ReadingStatus.completed:
        return 'Lido';
      case ReadingStatus.wishlist:
        return 'Em espera';
    }
  }

  Future<void> atualizarLivro(Book livroAtualizado) async {
    try {
      await _repository.atualizarLivro(livroAtualizado);
    } catch (e) {
      debugPrint('Erro ao atualizar livro: $e');
    }
  }

  Future<void> adicionarLivro(Book livro) async {
    try {
      await _repository.salvarLivro(livro);
    } catch (e) {
      debugPrint('Erro ao adicionar livro: $e');
      rethrow;
    }
  }

  Future<void> deletarLivro(String idDoLivro) async {
    try {
      await _repository.deletarLivro(idDoLivro);
    } catch (e) {
      debugPrint('Erro ao deletar livro: $e');
    }
  }

  Future<Map<String, dynamic>?> buscarNaHardcover(String isbn) async {
    try {
      return await _repository.buscarDadosLivro(isbn);
    } catch (e) {
      debugPrint('Erro ao buscar na Hardcover: $e');
      return null;
    }
  }
}
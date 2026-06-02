import 'package:flutter/material.dart';
import 'package:book_life/features/library/repositories/book_repository.dart';
import 'package:book_life/core/models/book_model.dart';

class AdicionarLivroViewModel extends ChangeNotifier {
  final BookRepository _repository = BookRepository();

  bool buscandoDadosDoLivro = false;
  bool salvandoLivro = false;
  String? mensagemDeErro;

  // Realiza a busca e retorna os dados brutos para preencher os campos da tela
  Future<Map<String, dynamic>?> pesquisarLivroPorIsbn(String isbnDigitado) async {
    final isbnLimpo = isbnDigitado.trim().toUpperCase().replaceAll(RegExp(r'[^0-9X]'), '');
    
    if (isbnLimpo.isEmpty) {
      _definirErro("Digite o ISBN.");
      return null;
    }

    buscandoDadosDoLivro = true;
    mensagemDeErro = null;
    notifyListeners();

    try {
      final dadosEncontrados = await _repository.buscarDadosLivro(isbnLimpo);
      
      if (dadosEncontrados == null) {
        _definirErro("O Hardcover não encontrou dados para este livro.");
      }
      
      return dadosEncontrados;
    } catch (_) {
      _definirErro("Falha ao buscar os dados do livro.");
      return null;
    } finally {
      buscandoDadosDoLivro = false;
      notifyListeners();
    }
  }

  // Persiste o livro no banco
  Future<bool> salvarNovoLivro(Book novoLivro) async {
    salvandoLivro = true;
    mensagemDeErro = null;
    notifyListeners();

    try {
      await _repository.salvarLivroNoBanco(novoLivro);
      return true;
    } catch (e) {
      _definirErro("Erro ao salvar o livro.");
      return false;
    } finally {
      salvandoLivro = false;
      notifyListeners();
    }
  }

  void _definirErro(String mensagem) {
    mensagemDeErro = mensagem;
    notifyListeners();
  }

  void limparErro() {
    mensagemDeErro = null;
    notifyListeners();
  }
}
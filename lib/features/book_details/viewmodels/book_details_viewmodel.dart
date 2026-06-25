import 'package:book_life/features/book_details/repositories/book_details_repository.dart';
import 'package:flutter/material.dart';
import 'package:book_life/core/models/book_model.dart';

class BookDetailsViewModel extends ChangeNotifier {
  final BookDetailsRepository _repository;

  Book? _book;
  bool _isLoading = false;
  Book? get book => _book;
  bool get isLoading => _isLoading;
  String? get bookId => _book?.id;

  BookDetailsViewModel({Book? initialBook, BookDetailsRepository? repository})
    : _repository = repository ?? BookDetailsRepository() {
    if (initialBook != null) {
      _book = initialBook;
    }
  }


  // Future<void> fetchBook(String id) async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     _book = await _repository.getBookById(id);
  //     if (_book == null) {
  //       _errorMessage = "Livro não encontrado.";
  //     }
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> toggleFavorite() async {
    final bookBackup = _book!;
    final updatedBook = _book!.toggleFavorite();

    _book = updatedBook;
    notifyListeners();

    try {
      await _repository.updateBook(updatedBook);
    } catch (e) {
      debugPrint("Erro ao favoritar: $e");
      _book = bookBackup;
      notifyListeners();
    }
  }

  void atualizarLivroRetornado(Book livroAtualizado) {
    _book = livroAtualizado;
    notifyListeners();
  }

  ImageProvider? get coverImageProvider {
    if(_book == null) return null;
    if (_book!.coverBytes != null && _book!.coverBytes!.isNotEmpty) {
      return MemoryImage(_book!.coverBytes!);
    } else if (_book!.coverUrl != null && _book!.coverUrl!.toString().isNotEmpty) {
      return NetworkImage(_book!.coverUrl.toString());
    }
    return null;
  }

  Future<void> updateProgress(Map<String, dynamic> result) async {
    if (_book == null) return;
    final bookBackup = _book!;
    final paginaAnterior = bookBackup.currentPage;
    final novaPagina = result['currentPage'] ?? paginaAnterior;
    final paginasLidasAgora = novaPagina - paginaAnterior;

    final updatedBook = _book!.copyWith(
      status: result['status'],
      rating: (result['rating'] as int).toDouble(),
      currentPage: novaPagina,
      totalPages: result['totalPages'],
    );

    _book = updatedBook;
    notifyListeners();

    try {
      await _repository.updateBookWithHistory(
        book: updatedBook,
        pagesReadInThisSession: paginasLidasAgora > 0 ? paginasLidasAgora : 0,
      );
    } catch (e) {
      debugPrint("Erro ao salvar progresso: $e");
      _book = bookBackup;
       notifyListeners();
      throw Exception('Não foi possível salvar o progresso');
     
    }
  }
}

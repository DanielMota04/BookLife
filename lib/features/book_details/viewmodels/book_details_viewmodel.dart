import 'package:book_life/features/book_details/repositories/book_details_repository.dart';
import 'package:flutter/material.dart';
import 'package:book_life/core/models/book_model.dart';

class BookDetailsViewModel extends ChangeNotifier {
  final BookDetailsRepository _repository;

  Book? _book;
  bool _isLoading = false;
  String? _errorMessage;

  Book? get book => _book;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get bookId => _book?.id;

  BookDetailsViewModel({
    Book? initialBook,
    BookDetailsRepository? repository,
  }) : _repository = repository ?? BookDetailsRepository() {
    if (initialBook != null) {
      _book = initialBook;
    }
  }

  Future<void> fetchBook(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _book = await _repository.getBookById(id);
      if (_book == null) {
        _errorMessage = "Livro não encontrado.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    if (_book == null || bookId == null) return;

    final updatedBook = _book!.toggleFavorite();
    _book = updatedBook;
    notifyListeners();

    try {
      await _repository.updateBook(updatedBook);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  void atualizarLivroRetornado(Book livroAtualizado) {
    this._book = livroAtualizado;
    notifyListeners(); 
  }
  Future<void> updateProgress(Map<String, dynamic> result) async {
    if (_book == null ) return;
    final bookBackup = _book!;
    final updatedBook = _book!.copyWith(
      status: result['status'],
      rating: (result['rating'] as int).toDouble(),
      currentPage: result['currentPage'],
      totalPages: result['totalPages'],
    );
    _book = updatedBook;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateBook(updatedBook);
    } catch (e) {
      debugPrint("Erro ao salvar progresso: ${e.toString()}");
      _book = bookBackup;
      _errorMessage = "Não foi possível salvar o progresso. Tente novamente.";
      notifyListeners();
    }
  }
}
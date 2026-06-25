import 'package:book_life/features/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class LogoutViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  LogoutViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> logout() async {
    _errorMessage = null;
    _isSuccess = false;
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.logout();
      _isSuccess = true;
    } catch (e) {
      _errorMessage = 'Ocorreu um erro ao sair';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
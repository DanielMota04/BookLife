import 'package:book_life/core/errors/auth_errors.dart';
import 'package:book_life/features/auth/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  ChangePasswordViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> submit(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    _errorMessage = null;
    _isSuccess = false;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = 'Todos os campos são obrigatórios';
      notifyListeners();
      return;
    } 

    if (newPassword.length < 8) {
      _errorMessage = 'A nova senha deve ter pelo menos 8 caracteres';
      notifyListeners();
      return;
    }

        if (currentPassword == newPassword) {
      _errorMessage = 'A nova senha não pode ser igual à senha atual';
      notifyListeners();
      return;
    }

    if (newPassword != confirmPassword) {
      _errorMessage = 'A nova senha e a confirmação devem ser iguais';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.changePassword(currentPassword, newPassword);
      _isSuccess = true;
    } on WrongPasswordException {
      _errorMessage = 'Senha atual incorreta';
    } on UnknownAuthException {
      _errorMessage = 'Ocorreu um erro ao tentar alterar a senha';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
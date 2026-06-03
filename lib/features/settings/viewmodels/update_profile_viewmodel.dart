import 'package:book_life/core/errors/auth_errors.dart';
import 'package:book_life/features/settings/repositories/profile_repository.dart';
import 'package:flutter/material.dart';

class UpdateProfileViewmodel extends ChangeNotifier {
  final ProfileRepository _repository;

  UpdateProfileViewmodel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  String? currentUsername;
  String? currentEmail;

  Future<void> submit(String? username, String? email) async {
    _errorMessage = null;
    _isSuccess = false;
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateData(username: username, email: email);
      _isSuccess = true;
    } on UserNotLoggedInException {
      _errorMessage = 'Usuário não está logado';
    } on RequiresRecentLoginException {
      _errorMessage = 'A operação requer login recente';
    } on UnknownAuthException {
      _errorMessage = 'Ocorreu um erro ao tentar atualizar o perfil';
    } catch (e) {
      _errorMessage = 'Ocorreu um erro inesperado';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserData() async {
    try {
      final data = await _repository.getCurrentUserData();
      currentUsername = data['nome'];
      currentEmail = data['email'];
      notifyListeners();
    } on UserNotLoggedInException {
      _errorMessage = 'Usuário não está logado';
      notifyListeners();
    }
  }
}

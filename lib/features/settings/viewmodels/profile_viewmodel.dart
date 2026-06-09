import 'package:book_life/core/errors/auth_errors.dart';
import 'package:book_life/features/settings/repositories/profile_repository.dart';
import 'package:flutter/material.dart';

class ProfileViewmodel extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileViewmodel(this._repository) {
    loadUserData();
  }

  bool _isLoading = false;
  String? _errorMessage;
  String? _username;
  String? _email;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get username => _username;
  String? get email => _email;

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _repository.getCurrentUserData();
      _username = data['nome'];
      _email = data['email'];
    } on UserNotLoggedInException {
      _errorMessage = 'Usuário não está logado';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

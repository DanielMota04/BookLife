import 'package:book_life/core/errors/auth_errors.dart';
import 'package:flutter/foundation.dart';
import 'package:book_life/features/auth/models/register_user_model.dart';
import 'package:book_life/features/auth/models/login_user_model.dart';
import 'package:book_life/features/auth/repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  RegisterViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'Todos os campos são obrigatórios.';
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'As senhas não coincidem';
      notifyListeners();
      return false;
    }

    if (password.length < 8) {
      _errorMessage = 'A senha deve ter no mínimo 8 caracteres';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.registerUser(
        RegisterUserModel(
          name: name,
          email: email,
          password: password,
          confirmPassword: confirmPassword
        ),
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  LoginViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Todos os campos são obrigatórios';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.loginUser(
        LoginUserModel(
          email: email,
          password: password,
        ),
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> loginWithGoogle() async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  try {
    await _repository.loginWithGoogle();
    return true;
  } on UnauthorizedDomainException {
    _errorMessage = 'Use seu e-mail @souunit para entrar!';
    return false;
  } on UnknownAuthException {
    _errorMessage = 'Erro ao entrar com o Google!';
    return false;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class UnauthorizedException extends AuthException {
  UnauthorizedException() : super('Usuário não autorizado');
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super('Esse email já está em uso');
}

class WrongPasswordException extends AuthException {
  WrongPasswordException() : super('A senha atual digitada está errada');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException() : super('A senha está muito fraca');
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('Usuário não encontrado');
}

class InvalidEmailException extends AuthException {
  InvalidEmailException() : super('O email está no formato errado');
}

class InvalidCredentialException extends AuthException {
  InvalidCredentialException() : super('Email ou senha errados');
}

class UserNotLoggedInException extends AuthException {
  UserNotLoggedInException() : super('Nenhum usuário logado');
}

class RequiresRecentLoginException extends AuthException {
  RequiresRecentLoginException() : super('A operação requer login recente');
}

class UnauthorizedDomainException extends AuthException {
  UnauthorizedDomainException() : super('Use seu e-mail @souunit para entrar');
}

class UnknownAuthException extends AuthException {
  final String code;
  UnknownAuthException(this.code) : super('Erro desconhecido');

  @override
  String toString() => 'UnknownAuthException: código=$code, $message';
}
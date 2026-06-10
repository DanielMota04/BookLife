class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class UnauthorizedException extends AuthException {
  UnauthorizedException() : super('Usuário não autorizado');
}

class WrongPasswordException extends AuthException {
  WrongPasswordException() : super('Senha atual incorreta');
}

class UserNotLoggedInException extends AuthException {
  UserNotLoggedInException() : super('Nenhum usuário logado');
}

class RequiresRecentLoginException extends AuthException {
  RequiresRecentLoginException() : super('A operação requer login recente');
}

class UnknownAuthException extends AuthException {
  final String code;
  UnknownAuthException(this.code) : super('Erro desconhecido');

  @override
  String toString() => 'UnknownAuthException: código=$code, $message';
}

class UnauthorizedDomainException extends AuthException {
  UnauthorizedDomainException() : super('Use seu e-mail @souunit para entrar');
}
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class WrongPasswordException extends AuthException {
  WrongPasswordException() : super('Senha atual incorreta');
}

class UnknownAuthException extends AuthException {
  final String code;
  UnknownAuthException(this.code) : super('Erro desconhecido');

  @override
  String toString() => 'UnknownAuthException: código=$code, $message';
}
class RegisterUserModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterUserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword
  });
}
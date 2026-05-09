class LoginRequestModel {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequestModel({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

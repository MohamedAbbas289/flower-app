abstract class Endpoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1";
  static const String signin = "$baseUrl/auth/signin";
  static const String signup = "$baseUrl/auth/signup";
  static const String logout = "$baseUrl/auth/logout";
  static const String forgotPassword = "$baseUrl/auth/forgotPassword";
  static const String verifyResetCode = "$baseUrl/auth/verifyResetCode";
  static const String resetPassword = "$baseUrl/auth/resetPassword";
}

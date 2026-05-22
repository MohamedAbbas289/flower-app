abstract class Endpoints {
  static const String baseUrl = "https://flower.elevateegy.com/api/v1";
  static const String imageBaseUrl = "https://flower.elevateegy.com/uploads/";
  static const String signin = "$baseUrl/auth/signin";
  static const String signup = "$baseUrl/auth/signup";
  static const String logout = "$baseUrl/auth/logout";
  static const String forgotPassword = "$baseUrl/auth/forgotPassword";
  static const String verifyResetCode = "$baseUrl/auth/verifyResetCode";
  static const String resetPassword = "$baseUrl/auth/resetPassword";
  static const String getBestSeller = "$baseUrl/best-seller";
  static const String getCategories = "$baseUrl/categories";
  static const String getOccasions = "$baseUrl/occasions";
  static const String getProducts = "$baseUrl/products";
  static const String home = "$baseUrl/home";
  static const String changePassword = '$baseUrl/auth/change-password';
  static const String getProfile = '$baseUrl/auth/profile-data';
  static const String editProfile = '$baseUrl/auth/editProfile';


}

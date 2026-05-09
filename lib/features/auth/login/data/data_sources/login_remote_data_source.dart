import 'package:flower_app/core/models/auth_response.dart';

abstract interface class LoginRemoteDataSource {
  Future<AuthResponse> login({
    required String email,
    required String password,
  });
}

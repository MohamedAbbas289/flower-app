import 'package:flower_app/features/login/api/responses/login_response.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponse> login({
    required String email,
    required String password,
  });
}

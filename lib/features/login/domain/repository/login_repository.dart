import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

abstract class LoginRepository {
  Future<BaseResponse<AuthResponseEntity>> login({
    required String email,
    required String password,
  });
}

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/login/domain/model/login_entity.dart';

abstract class LoginRepository {
  Future<BaseResponse<LoginEntity>> login({
    required String email,
    required String password,
  });
}

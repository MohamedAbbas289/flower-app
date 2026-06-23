import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

import 'package:injectable/injectable.dart';

import '../../api/request_models/login_request_model.dart';
import '../repository/login_repository.dart';

@injectable
class LoginUseCase {
  final LoginRepository _loginRepository;

  LoginUseCase(this._loginRepository);

  Future<BaseResponse<AuthResponseEntity>> execute({
    required LoginRequestModel requestModel,
  }) {
    return _loginRepository.login(
      email: requestModel.email,
      password: requestModel.password,
      rememberMe: requestModel.rememberMe,
    );
  }
}

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/login/domain/model/login_entity.dart';
import 'package:flower_app/features/login/domain/repository/login_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginUseCase {
  final LoginRepository _loginRepository;

  LoginUseCase(this._loginRepository);

  Future<BaseResponse<LoginEntity>> call({
    required String email,
    required String password,
  }) {
    return _loginRepository.login(email: email, password: password);
  }
}

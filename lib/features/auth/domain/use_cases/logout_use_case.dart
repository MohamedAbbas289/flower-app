import 'package:flower_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../repository_contract/auth_repository_contract.dart';

@injectable
class LogoutUseCase {
  final AuthRepositoryContract _authRepositoryContract;

  LogoutUseCase(this._authRepositoryContract);

  Future<BaseResponse<void>> execute() {
    return _authRepositoryContract.logout();
  }
}

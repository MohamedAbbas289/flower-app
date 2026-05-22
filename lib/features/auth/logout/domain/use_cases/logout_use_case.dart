import 'package:flower_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../repository/logout_repository.dart';

@injectable
class LogoutUseCase {
  final LogoutRepository _logoutRepository;

  LogoutUseCase(this._logoutRepository);

  Future<BaseResponse<void>> execute() {
    return _logoutRepository.logout();
  }
}

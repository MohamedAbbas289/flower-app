import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/logout_repository.dart';
import '../data_sources/logout_remote_data_source.dart';

@Injectable(as: LogoutRepository)
class LogoutRepositoryImpl implements LogoutRepository {
  final LogoutRemoteDataSource _remoteDataSource;
  final AuthManager _authManager;

  LogoutRepositoryImpl(this._remoteDataSource, this._authManager);

  @override
  Future<BaseResponse<void>> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {}
    try {
      await _authManager.logout();
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
    return SuccessBaseResponse(data: null);
  }
}

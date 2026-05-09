import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:flower_app/features/login/domain/repository/login_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/models/auth_response.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource _remoteDataSource;
  final AuthManager _authManager;

  LoginRepositoryImpl(this._remoteDataSource, this._authManager);

  @override
  Future<BaseResponse<AuthResponseEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      final entity = response.toEntity();
      await _authManager.setAuthData(
        token: entity.token ?? '',
        rememberMe: rememberMe,
        userId: entity.user?.id,
      );
      return SuccessBaseResponse(data: entity);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}

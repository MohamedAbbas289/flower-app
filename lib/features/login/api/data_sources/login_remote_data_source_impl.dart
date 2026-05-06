import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/features/login/api/login_api_client/login_api_client.dart';
import 'package:flower_app/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final LoginApiClient _loginApiClient;

  LoginRemoteDataSourceImpl(this._loginApiClient);

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _loginApiClient.login({
      ApiParam.email: email,
      ApiParam.password: password,
    });
  }
}

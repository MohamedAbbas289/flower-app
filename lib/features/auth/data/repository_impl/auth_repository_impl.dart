import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/auth/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository_contract/auth_repository_contract.dart';
import '../data_sources_contract/auth_remote_data_source_contract.dart';

@Injectable(as: AuthRepositoryContract)
class AuthRepositoryImpl implements AuthRepositoryContract {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthManager _authManager;

  AuthRepositoryImpl(this._remoteDataSource, this._authManager);

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

  @override
  Future<BaseResponse<AuthResponseEntity>> signup({
    required SignupRequestModel requestModel,
  }) async {
    final response = await _remoteDataSource.signup(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<AuthResponse>():
        final entity = response.data.toEntity();
        return SuccessBaseResponse<AuthResponseEntity>(data: entity);

      case ErrorBaseResponse<AuthResponse>():
        return ErrorBaseResponse<AuthResponseEntity>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(
    String email,
  ) async {
    try {
      return await _remoteDataSource.forgotPassword(email);
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code) async {
    try {
      return await _remoteDataSource.verifyCode(code);
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      return await _remoteDataSource.resetPassword(
        email: email,
        newPassword: newPassword,
      );
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}

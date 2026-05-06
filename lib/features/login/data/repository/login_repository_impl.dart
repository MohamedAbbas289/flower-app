import 'package:dio/dio.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:flower_app/features/login/domain/repository/login_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/models/auth_response.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource _remoteDataSource;

  LoginRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<AuthResponseEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return SuccessBaseResponse(data: response.toEntity());
    } on DioException catch (e) {
      return ErrorBaseResponse(exception: _normalizeDioError(e));
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  DioException _normalizeDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] != null && data['message'] == null) {
      final normalizedData = {'message': data['error'].toString()};
      final normalizedResponse = Response<Map<String, dynamic>>(
        requestOptions: e.requestOptions,
        data: normalizedData,
        statusCode: e.response?.statusCode,
        statusMessage: e.response?.statusMessage,
        headers: e.response?.headers,
      );
      return DioException(
        requestOptions: e.requestOptions,
        response: normalizedResponse,
        type: e.type,
        error: e.error,
        message: e.message,
        stackTrace: e.stackTrace,
      );
    }
    return e;
  }
}

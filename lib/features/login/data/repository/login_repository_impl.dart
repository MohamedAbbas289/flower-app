import 'package:dio/dio.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:flower_app/features/login/data/model/login_model.dart';
import 'package:flower_app/features/login/domain/model/login_entity.dart';
import 'package:flower_app/features/login/domain/repository/login_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource _remoteDataSource;

  LoginRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<LoginEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      final model = LoginModel.fromResponse(response);
      final entity = LoginEntity.fromModel(model);
      return SuccessBaseResponse(data: entity);
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

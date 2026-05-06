import 'package:dio/dio.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget-password/domain/repositories/forget_password_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ForgetPasswordRepo)
class ForgetPasswordRepoImpl implements ForgetPasswordRepo {
  final ForgetPasswordRemoteDataSourceImpl remote;

  ForgetPasswordRepoImpl(this.remote);

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(
    String email,
  ) async {
    try {
      final response = await remote.forgotPassword(email);
      return SuccessBaseResponse(data: response);
    } on DioException catch (e) {
      return ErrorBaseResponse(exception: e);
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code) async {
    try {
      final response = await remote.verifyCode(code);
      return SuccessBaseResponse(data: response);
    } on DioException catch (e) {
      return ErrorBaseResponse(exception: e);
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
      final response = await remote.resetPassword(
        email: email,
        newPassword: newPassword,
      );
      return SuccessBaseResponse(data: response);
    } on DioException catch (e) {
      return ErrorBaseResponse(exception: e);
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}

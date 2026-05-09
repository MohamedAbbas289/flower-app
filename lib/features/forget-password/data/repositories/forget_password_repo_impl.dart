import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/data/data_source/forget_password_remote_data_source.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget-password/domain/repositories/forget_password_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgetPasswordRepo)
class ForgetPasswordRepoImpl implements ForgetPasswordRepo {
  final ForgetPasswordRemoteDataSource _remote;

  ForgetPasswordRepoImpl(this._remote);

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(
    String email,
  ) async {
    try {
      final response = await _remote.forgotPassword(email);
      return response;
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code) async {
    try {
      final response = await _remote.verifyCode(code);
      return response;
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
      final response = await _remote.resetPassword(
        email: email,
        newPassword: newPassword,
      );
      return response;
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}

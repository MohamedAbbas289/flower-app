import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/change_password/data/model/change_password_response.dart';

abstract interface class ChangePasswordRemoteDataSourceContract {
  Future<BaseResponse<ChangePasswordResponse>> changePassword({
    required String password,
    required String newPassword,
  });
}

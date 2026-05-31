import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<BaseResponse<AuthResponse>> getProfileData();
}

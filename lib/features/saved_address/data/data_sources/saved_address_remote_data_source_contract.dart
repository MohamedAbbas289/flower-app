import '../../../../config/base_response/base_response.dart';
import '../../../../core/models/auth_response.dart';

abstract interface class SavedAddressRemoteDataSourceContract {
  Future <BaseResponse<AuthResponse>> getSavedAddress({String? token});
}
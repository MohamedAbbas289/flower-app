import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/signup_request_model.dart';
import '../../domain/repositories_contract/signup_repository_contract.dart';
import '../datasources_contract/signup_remote_datasource_contract.dart';

@Injectable(as: SignupRepositoryContract)
class SignupRepositoryImpl implements SignupRepositoryContract {
  SignupRepositoryImpl(this._remoteDataSource);
  final SignupRemoteDatasourceContract _remoteDataSource;
  @override
  Future<BaseResponse<AuthResponseEntity>> signup({
    required SignupRequestModel requestModel,
  }) async {
    final response = await _remoteDataSource.signup(requestModel: requestModel);

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
}

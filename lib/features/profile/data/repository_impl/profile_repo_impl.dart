import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../domain/repository_contract/profile_repo_contract.dart';
import '../data_sources_contract/profile_remote_data_source_contract.dart';

@Injectable(as: ProfileRepoContract)
class ProfileRepoImpl implements ProfileRepoContract {
  final ProfileRemoteDataSourceContract profileRemoteDataSourceContract;

  ProfileRepoImpl(this.profileRemoteDataSourceContract);

  @override
  Future<BaseResponse<AuthResponseEntity>> getProfileData() async {
    final response = await profileRemoteDataSourceContract.getProfileData();
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


import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../domain/entities/user_entitiy.dart';
import '../../domain/repositories/get_profile_repo_contract.dart';
import '../data_sources/profile_remote_data_source_contract.dart';
import '../models/get_user_dto.dart';

@Injectable(as: GetProfileRepoContract)
class ProfileRepoImpl  implements GetProfileRepoContract{

  final ProfileRemoteDataSourceContract profileRemoteDataSourceContract;

  ProfileRepoImpl(this.profileRemoteDataSourceContract);


  @override
  Future<BaseResponse<GetUserEntity>> getProfileData() async {
    final response = await profileRemoteDataSourceContract.getProfileData();
    switch (response){
      case SuccessBaseResponse<GetUserDto>():
        return SuccessBaseResponse<GetUserEntity>(data: response.data.toDomain());
      case ErrorBaseResponse<GetUserDto>():
        return ErrorBaseResponse<GetUserEntity>(exception: response.exception);

    }


  }



}

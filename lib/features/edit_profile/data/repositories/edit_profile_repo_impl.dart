import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/edit_profile/data/data_sources/edit_profile_data_source_contract.dart';
import 'package:flower_app/features/edit_profile/data/models/edit_user_dto.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/edit_user_entity.dart';
import '../../domain/repositories/edit_profile_repo_contract.dart';


@Injectable(as: EditProfileRepoContract)
class EditProfileRepoImpl implements EditProfileRepoContract {
  final EditProfileDataSourceContract editProfileDataSourceContract;

  EditProfileRepoImpl(this.editProfileDataSourceContract);

  @override
  Future<BaseResponse<EditUserEntity>> editProfile({String? token}) async {
    final response = await editProfileDataSourceContract.editProfile(
      token: token,
    );
    switch (response) {
      case SuccessBaseResponse<EditUserDto>():
        return SuccessBaseResponse<EditUserEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<EditUserDto>():
        return ErrorBaseResponse<EditUserEntity>(exception: response.exception);
    }
  }
}

import 'dart:io';

import 'package:flower_app/features/edit_profile/domain/entities/edit_user_entity.dart';

import '../../../../config/base_response/base_response.dart';
import '../../data/models/edit_user_dto.dart';

abstract interface class EditProfileRepoContract {
  Future<BaseResponse<EditUserEntity>> editProfile({
    String? token,
    required EditUserDto request,
    File? image,
  });
}

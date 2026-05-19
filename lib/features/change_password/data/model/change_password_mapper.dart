import 'package:flower_app/features/change_password/data/model/change_password_response.dart';
import 'package:flower_app/features/change_password/domain/entity/change_password_entity.dart';

extension ChangePasswordMapper on ChangePasswordResponse {
  ChangePasswordEntity toEntity() {
    return ChangePasswordEntity(message: message ?? '', token: token ?? '');
  }
}

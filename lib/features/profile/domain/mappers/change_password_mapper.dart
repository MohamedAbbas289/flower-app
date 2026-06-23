import 'package:flower_app/features/profile/data/models/change_password_response.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';

extension ChangePasswordMapper on ChangePasswordResponse {
  ChangePasswordEntity toEntity() {
    return ChangePasswordEntity(message: message ?? '', token: token ?? '');
  }
}

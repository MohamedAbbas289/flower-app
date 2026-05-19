import 'package:flower_app/core/values/api_param.dart';

class ChangePasswordRequestModel {
  final String password;
  final String newPassword;

  const ChangePasswordRequestModel({
    required this.password,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {ApiParam.password: password, ApiParam.newPassword: newPassword};
  }
}

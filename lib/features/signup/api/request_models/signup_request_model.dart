import 'package:flower_app/core/values/api_param.dart';

class SignupRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String rePassword;
  final String phone;
  final String gender;

  const SignupRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.rePassword,
    required this.phone,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      ApiParam.firstName: firstName,
      ApiParam.lastName: lastName,
      ApiParam.email: email,
      ApiParam.password: password,
      ApiParam.rePassword: rePassword,
      ApiParam.phone: phone,
      ApiParam.gender: gender,
    };
  }
}

import 'package:flower_app/core/values/api_param.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signup_request_model.g.dart';

@JsonSerializable()
class SignupRequestModel {
  @JsonKey(name: ApiParam.firstName)
  final String firstName;

  @JsonKey(name: ApiParam.lastName)
  final String lastName;

  @JsonKey(name: ApiParam.email)
  final String email;

  @JsonKey(name: ApiParam.password)
  final String password;

  @JsonKey(name: ApiParam.rePassword)
  final String rePassword;

  @JsonKey(name: ApiParam.phone)
  final String phone;

  @JsonKey(name: ApiParam.gender)
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

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestModelToJson(this);
}
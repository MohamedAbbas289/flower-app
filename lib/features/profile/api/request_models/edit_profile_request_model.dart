import 'package:flower_app/core/values/api_param.dart';

class EditProfileRequestModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  const EditProfileRequestModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (firstName != null) map[ApiParam.firstName] = firstName;
    if (lastName != null) map[ApiParam.lastName] = lastName;
    if (email != null) map[ApiParam.email] = email;
    if (phone != null) map[ApiParam.phone] = phone;
    return map;
  }
}

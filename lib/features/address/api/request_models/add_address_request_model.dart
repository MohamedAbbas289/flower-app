import 'package:flower_app/core/values/api_param.dart';

class AddAddressRequestModel {
  final String? street;
  final String? phone;
  final String? city;
  final String? lat;
  final String? long;
  final String? username;

  const AddAddressRequestModel({
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,
  });

  Map<String, dynamic> toJson() => {
    ApiParam.street: street,
    ApiParam.phone: phone,
    ApiParam.city: city,
    ApiParam.lat: lat,
    ApiParam.long: long,
    ApiParam.username: username,
  };
}

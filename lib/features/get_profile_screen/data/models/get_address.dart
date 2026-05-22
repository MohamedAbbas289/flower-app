import 'package:json_annotation/json_annotation.dart';

part  'get_address.g.dart';
@JsonSerializable()

class GetAddress {
  @JsonKey(name: "street")
  String? street;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "city")
  String? city;
  @JsonKey(name: "lat")
  String? lat;
  @JsonKey(name: "long")
  String? long;
  @JsonKey(name: "username")
  String? username;
  @JsonKey(name: "_id")
  String? id;

  GetAddress({
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,
    this.id,
  });

  factory GetAddress.fromJson(Map<String, dynamic> json) => _$GetAddressFromJson(json);

  Map<String, dynamic> toJson() => _$GetAddressToJson(this);
}
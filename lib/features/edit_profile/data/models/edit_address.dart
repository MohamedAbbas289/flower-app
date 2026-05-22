import 'package:json_annotation/json_annotation.dart';

part 'edit_address.g.dart';

@JsonSerializable()
class EditAddress {
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

  EditAddress({
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,
    this.id,
  });

  factory EditAddress.fromJson(Map<String, dynamic> json) =>
      _$EditAddressFromJson(json);

  Map<String, dynamic> toJson() => _$EditAddressToJson(this);
}



import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/saved_address_entity.dart';
part 'saved_address_dto.g.dart';
@JsonSerializable()
class SavedAddressDto {
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


  SavedAddressDto({
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,

  });

  factory SavedAddressDto.fromJson(Map<String, dynamic> json) => _$SavedAddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SavedAddressDtoToJson(this);
  SavedAddressEntity toDomain(){
    return SavedAddressEntity(
      street: street,
      phone: phone,
      city: city,
      lat: lat,
      long: long,
      username: username,

    );
  }
}

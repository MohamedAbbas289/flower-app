import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/address_entity.dart';

part 'add_address_dto.g.dart';

@JsonSerializable()
class AddAddressDto {
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

  AddAddressDto({
    this.street,
    this.phone,
    this.city,
    this.lat,
    this.long,
    this.username,
    this.id,
  });

  factory AddAddressDto.fromJson(Map<String, dynamic> json) => _$AddAddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressDtoToJson(this);

  AddressEntity toDomain() {
    return AddressEntity(
      street: street,
      phone: phone,
      city: city,
      lat: lat,
      long: long,
      username: username,
      id: id,
    );
  }
  }

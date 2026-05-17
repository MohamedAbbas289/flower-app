import 'package:json_annotation/json_annotation.dart';

import 'get_address.dart';

part 'get_user_dto.g.dart';
@JsonSerializable()

class GetUserDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "password")
  String? password;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "photo")
  String? photo;
  @JsonKey(name: "role")
  String? role;
  @JsonKey(name: "wishlist")
  List<dynamic>? wishlist;
  @JsonKey(name: "addresses")
  List<GetAddress>? addresses;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "passwordChangedAt")
  DateTime? passwordChangedAt;

  GetUserDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.wishlist,
    this.addresses,
    this.createdAt,
    this.passwordChangedAt,
  });

  factory GetUserDto.fromJson(Map<String, dynamic> json) => _$GetUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserDtoToJson(this);
  GetUserDto toDomain(){
    return GetUserDto(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      gender: gender,
      phone: phone,
      photo: photo,
      role: role,
      wishlist: wishlist,
      addresses: addresses,
      createdAt: createdAt,
      passwordChangedAt: passwordChangedAt,
    );
  }
  }


import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/edit_user_entity.dart';
import 'edit_address.dart';

part 'edit_user_dto.g.dart';

@JsonSerializable()
class EditUserDto {
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
  List<EditAddress>? addresses;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "passwordChangedAt")
  DateTime? passwordChangedAt;

  EditUserDto({
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

  factory EditUserDto.fromJson(Map<String, dynamic> json) => _$EditUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EditUserDtoToJson(this);

  EditUserEntity toDomain() {
    return EditUserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      gender: gender,
      phone: phone,
      photo: photo,
      role: role,
      createdAt: createdAt,
      passwordChangedAt: passwordChangedAt,
    );
  }

  }




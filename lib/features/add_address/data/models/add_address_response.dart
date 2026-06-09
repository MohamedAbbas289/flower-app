import 'package:json_annotation/json_annotation.dart';
import 'add_address_dto.dart';
part 'add_address_response.g.dart';

@JsonSerializable()
class AddAddressResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "address")
  List<AddAddressDto>? address;

  AddAddressResponse({
    this.message,
    this.address,
  });

  factory AddAddressResponse.fromJson(Map<String, dynamic> json) => _$AddAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressResponseToJson(this);
}



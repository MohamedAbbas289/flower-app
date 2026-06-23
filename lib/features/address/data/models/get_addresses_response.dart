import 'package:json_annotation/json_annotation.dart';
import 'add_address_dto.dart';

part 'get_addresses_response.g.dart';

@JsonSerializable()
class GetAddressesResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "addresses")
  final List<AddAddressDto>? addresses;

  const GetAddressesResponse({this.message, this.addresses});

  factory GetAddressesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAddressesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAddressesResponseToJson(this);
}
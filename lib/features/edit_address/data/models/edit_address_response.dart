import 'package:json_annotation/json_annotation.dart';
import '../../../add_address/data/models/add_address_dto.dart';

part 'edit_address_response.g.dart';

@JsonSerializable()
class EditAddressResponse {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "addresses")
  final List<AddAddressDto>? addresses;

  const EditAddressResponse({this.message, this.addresses});

  factory EditAddressResponse.fromJson(Map<String, dynamic> json) =>
      _$EditAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditAddressResponseToJson(this);
}
import 'package:flower_app/features/saved_address/data/models/saved_address_dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'saved_address_response.g.dart';
@JsonSerializable()
class SavedAddressResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "addresses")
  List<SavedAddressDto>? addresses;

  SavedAddressResponse({
    this.message,
    this.addresses,
  });

  factory SavedAddressResponse.fromJson(Map<String, dynamic> json) => _$SavedAddressResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SavedAddressResponseToJson(this);
}
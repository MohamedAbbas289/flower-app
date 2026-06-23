import 'package:json_annotation/json_annotation.dart';

import 'home_metadata.dart';
import 'home_occasion_dto.dart';
part 'home_occasions_response.g.dart';

@JsonSerializable()
class HomeOccasionsResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  Metadata? metadata;
  @JsonKey(name: "occasions")
  List<OccasionDto>? occasions;

  HomeOccasionsResponse({
    this.message,
    this.metadata,
    this.occasions,
  });

  factory HomeOccasionsResponse.fromJson(Map<String, dynamic> json) => _$HomeOccasionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeOccasionsResponseToJson(this);
}





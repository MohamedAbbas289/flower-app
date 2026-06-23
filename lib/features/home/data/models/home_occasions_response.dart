import 'package:json_annotation/json_annotation.dart';

import '../metadata.dart';
import 'occasion.dart';
part 'occasions_response.g.dart';

@JsonSerializable()
class OccasionsResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  Metadata? metadata;
  @JsonKey(name: "occasions")
  List<OccasionDto>? occasions;

  OccasionsResponse({
    this.message,
    this.metadata,
    this.occasions,
  });

  factory OccasionsResponse.fromJson(Map<String, dynamic> json) => _$OccasionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionsResponseToJson(this);
}





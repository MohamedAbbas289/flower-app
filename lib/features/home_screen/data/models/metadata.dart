import 'package:json_annotation/json_annotation.dart';
part 'metadata.g.dart';
@JsonSerializable()
class Metadata {
  @JsonKey(name: "currentPage")
  int? currentPage;
  @JsonKey(name: "limit")
  int? limit;
  @JsonKey(name: "totalPages")
  int? totalPages;
  @JsonKey(name: "totalItems")
  int? totalItems;

  Metadata({
    this.currentPage,
    this.limit,
    this.totalPages,
    this.totalItems,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
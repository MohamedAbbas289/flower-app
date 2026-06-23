import 'package:json_annotation/json_annotation.dart';

import 'home_category_dto.dart';
import 'home_metadata.dart';
part 'home_category_response.g.dart';
@JsonSerializable()
class CategoryResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  Metadata? metadata;
  @JsonKey(name: "categories")
  List<CategoryDto>? categories;

  CategoryResponse({
    this.message,
    this.metadata,
    this.categories,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
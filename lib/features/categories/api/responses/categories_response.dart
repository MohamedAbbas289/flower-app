import 'package:flower_app/core/models/metadata_model.dart';
import 'package:flower_app/features/categories/data/models/category_model.dart';
import 'package:flower_app/features/categories/domain/entities/categories_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_response.g.dart';

@JsonSerializable()
class CategoriesResponse {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'metadata')
  final MetadataModel? metadata;

  @JsonKey(name: 'categories')
  final List<CategoryModel>? categories;

  const CategoriesResponse({this.message, this.metadata, this.categories});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);

  CategoriesResponseEntity toEntity() {
    return CategoriesResponseEntity(
      categories: categories?.map((e) => e.toEntity()).toList() ?? [],
      metadata: metadata?.toEntity(),
    );
  }
}

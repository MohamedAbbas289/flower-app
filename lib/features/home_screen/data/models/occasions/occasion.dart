import 'package:flower_app/features/home_screen/domain/entities/occasion_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'occasion.g.dart';

@JsonSerializable()
class OccasionDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "slug")
  String? slug;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "isSuperAdmin")
  bool? isSuperAdmin;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "productsCount")
  int? productsCount;

  OccasionDto({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  });

  factory OccasionDto.fromJson(Map<String, dynamic> json) => _$OccasionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionDtoToJson(this);

  OccasionModel toDomain() {
    return OccasionModel(
      id: id,
      name: name,
      slug: slug,
      image: image,
      isSuperAdmin: isSuperAdmin,
      createdAt: createdAt,
      updatedAt: updatedAt,
      productsCount: productsCount,
    );
  }
}

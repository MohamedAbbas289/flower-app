import 'package:flower_app/features/home/domain/entities/home_occasion_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_occasion_dto.g.dart';

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

  HomeOccasionEntity toDomain() {
    return HomeOccasionEntity(
      id: id,
      name: name,
      image: image,
      productsCount: productsCount,
    );
  }
}

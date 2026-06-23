import 'package:flower_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'occasions_response.g.dart';

@JsonSerializable()
class OccasionsResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  Metadata? metadata;
  @JsonKey(name: "occasions")
  List<Occasion>? occasions;

  OccasionsResponse({this.message, this.metadata, this.occasions});

  factory OccasionsResponse.fromJson(Map<String, dynamic> json) =>
      _$OccasionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionsResponseToJson(this);
}

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

  Metadata({this.currentPage, this.limit, this.totalPages, this.totalItems});

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

@JsonSerializable()
class Occasion {
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

  Occasion({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.productsCount,
  });

  factory Occasion.fromJson(Map<String, dynamic> json) =>
      _$OccasionFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionToJson(this);
}

extension OccasionsMapper on OccasionsResponse {
  OccasionsEntity toEntity() {
    return OccasionsEntity(
      currentPage: metadata?.currentPage ?? 1,
      totalPages: metadata?.totalPages ?? 1,
      occasions:
          occasions
              ?.map<OccasionEntity>((e) => e.toOccasionEntity())
              .toList() ??
          [],
    );
  }
}

extension OccasionMapper on Occasion {
  OccasionEntity toOccasionEntity() {
    return OccasionEntity(
      id: id ?? '',
      name: name ?? '',
      productsCount: productsCount ?? 0,
    );
  }
}

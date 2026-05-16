import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'best_seller.g.dart';

@JsonSerializable()
class BestSellerDto {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "slug")
  String? slug;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "imgCover")
  String? imgCover;
  @JsonKey(name: "images")
  List<String>? images;
  @JsonKey(name: "price")
  int? price;
  @JsonKey(name: "priceAfterDiscount")
  int? priceAfterDiscount;
  @JsonKey(name: "discount")
  int? discount;
  @JsonKey(name: "rateAvg")
  int? rateAvg;
  @JsonKey(name: "rateCount")
  int? rateCount;
  @JsonKey(name: "sold")
  int? sold;
  @JsonKey(name: "quantity")
  int? quantity;
  @JsonKey(name: "category")
  String? category;
  @JsonKey(name: "occasion")
  String? occasion;
  @JsonKey(name: "isSuperAdmin")
  bool? isSuperAdmin;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "__v")
  int? v;
  @JsonKey(name: "id")
  String? bestSellerId;

  BestSellerDto({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.discount,
    this.rateAvg,
    this.rateCount,
    this.sold,
    this.quantity,
    this.category,
    this.occasion,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.bestSellerId,
  });

  factory BestSellerDto.fromJson(Map<String, dynamic> json) => _$BestSellerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BestSellerDtoToJson(this);

  BestSellerModel toDomain() {
    return BestSellerModel(
      id: id,
      title: title,
      slug: slug,
      description: description,
      imgCover: imgCover,
      images: images,
      price: price,
      priceAfterDiscount: priceAfterDiscount,
      discount: discount,
      rateAvg: rateAvg,
      rateCount: rateCount,
      sold: sold,
      quantity: quantity,
      category: category,
      occasion: occasion,
      isSuperAdmin: isSuperAdmin,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
      bestSellerId: bestSellerId,
    );
  }
}

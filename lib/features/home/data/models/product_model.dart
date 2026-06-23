import 'package:flower_app/features/home/domain/entities/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'slug')
  final String? slug;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'imgCover')
  final String? imgCover;

  @JsonKey(name: 'images')
  final List<String>? images;

  @JsonKey(name: 'price')
  final num? price;

  @JsonKey(name: 'priceAfterDiscount')
  final num? priceAfterDiscount;

  @JsonKey(name: 'discount')
  final num? discount;

  @JsonKey(name: 'rateAvg')
  final num? rateAvg;

  @JsonKey(name: 'rateCount')
  final num? rateCount;

  @JsonKey(name: 'sold')
  final num? sold;

  @JsonKey(name: 'quantity')
  final num? quantity;

  @JsonKey(name: 'category')
  final String? categoryId;

  @JsonKey(name: 'occasion')
  final String? occasionId;

  @JsonKey(name: 'isInWishlist')
  final bool? isInWishlist;

  @JsonKey(name: 'favoriteId')
  final String? favoriteId;

  const ProductModel({
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
    this.categoryId,
    this.occasionId,
    this.isInWishlist,
    this.favoriteId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

extension ProductModelMapper on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
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
      categoryId: categoryId,
      occasionId: occasionId,
      isInWishlist: isInWishlist,
      favoriteId: favoriteId,
    );
  }
}

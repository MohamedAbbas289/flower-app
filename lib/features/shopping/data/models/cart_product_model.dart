import 'package:flower_app/features/shopping/domain/entities/cart_product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_product_model.g.dart';

@JsonSerializable()
class CartProductModel {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'imgCover')
  final String? imgCover;
  @JsonKey(name: 'price')
  final int? price;

  const CartProductModel({
    this.id,
    this.title,
    this.description,
    this.imgCover,
    this.price,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) =>
      _$CartProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartProductModelToJson(this);
}

extension CartProductModelMapper on CartProductModel {
  CartProductEntity toEntity() => CartProductEntity(
        id: id ?? '',
        title: title ?? '',
        description: description ?? '',
        imgCover: imgCover ?? '',
        price: price ?? 0,
      );
}
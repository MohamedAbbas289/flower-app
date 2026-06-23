import 'package:flower_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_product_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cart_product_model.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  @JsonKey(name: '_id')
  final String? cartItemId;
  @JsonKey(name: 'product')
  final CartProductModel? product;
  @JsonKey(name: 'price')
  final int? price;
  @JsonKey(name: 'quantity')
  final int? quantity;

  const CartItemModel({
    this.cartItemId,
    this.product,
    this.price,
    this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}

extension CartItemModelMapper on CartItemModel {
  CartItemEntity toEntity() => CartItemEntity(
        cartItemId: cartItemId ?? '',
        product: product?.toEntity() ?? const CartProductEntity(
          id: '',
          title: '',
          description: '',
          imgCover: '',
          price: 0,
        ),
        price: price ?? 0,
        quantity: quantity ?? 0,
      );
}
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'cartItems')
  final List<CartItemModel>? cartItems;
  @JsonKey(name: 'totalPrice')
  final int? totalPrice;
  @JsonKey(name: 'totalPriceAfterDiscount')
  final int? totalPriceAfterDiscount;
  @JsonKey(name: 'discount')
  final int? discount;

  const CartModel({
    this.id,
    this.cartItems,
    this.totalPrice,
    this.totalPriceAfterDiscount,
    this.discount,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
// ToDo : eng loay => what if response returned null, wrong handling here
extension CartModelMapper on CartModel {
  CartEntity toEntity() => CartEntity(
        id: id ?? '',
        cartItems: cartItems?.map((e) => e.toEntity()).toList() ?? [],
        totalPrice: totalPrice ?? 0,
        totalPriceAfterDiscount: totalPriceAfterDiscount ?? 0,
        discount: discount ?? 0,
        numOfCartItems: cartItems?.length ?? 0,
      );
}
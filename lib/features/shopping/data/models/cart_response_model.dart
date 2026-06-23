import 'package:flower_app/features/shopping/data/models/cart_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_response_model.g.dart';

@JsonSerializable()
class CartResponseModel {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'numOfCartItems')
  final int? numOfCartItems;
  @JsonKey(name: 'cart')
  final CartModel? cart;

  const CartResponseModel({
    this.message,
    this.numOfCartItems,
    this.cart,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CartResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartResponseModelToJson(this);
}
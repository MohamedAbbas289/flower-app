import 'package:flower_app/features/shopping/domain/entities/order_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'order_product_model.dart';

part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItemModel {
  @JsonKey(name: 'product')
  final OrderProductModel? product;

  @JsonKey(name: 'price')
  final num? price;

  @JsonKey(name: 'quantity')
  final num? quantity;

  @JsonKey(name: '_id')
  final String? id;

  const OrderItemModel({this.product, this.price, this.quantity, this.id});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}

extension OrderItemModelMapper on OrderItemModel {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      product: product?.toEntity(),
      price: price,
      quantity: quantity,
      id: id,
    );
  }
}

import 'package:flower_app/core/models/metadata_model.dart';
import 'package:flower_app/features/orders/data/models/order_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'orders_response.g.dart';

@JsonSerializable()
class OrdersResponse {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'metadata')
  final MetadataModel? metadata;

  @JsonKey(name: 'orders')
  final List<OrderModel>? orders;

  const OrdersResponse({this.message, this.metadata, this.orders});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$OrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResponseToJson(this);
}

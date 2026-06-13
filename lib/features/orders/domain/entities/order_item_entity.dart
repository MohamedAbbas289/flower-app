import 'order_product_entity.dart';

class OrderItemEntity {
  final OrderProductEntity? product;
  final num? price;
  final num? quantity;
  final String? id;

  const OrderItemEntity({this.product, this.price, this.quantity, this.id});
}

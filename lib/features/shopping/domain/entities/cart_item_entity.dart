import 'package:equatable/equatable.dart';
import 'cart_product_entity.dart';

class CartItemEntity extends Equatable {
  final String cartItemId;
  final CartProductEntity product;
  final int price;
  final int quantity;

  const CartItemEntity({
    required this.cartItemId,
    required this.product,
    required this.price,
    required this.quantity,
  });

  CartItemEntity copyWith({int? quantity}) {
    return CartItemEntity(
      cartItemId: cartItemId,
      product: product,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [cartItemId, product, price, quantity];
}
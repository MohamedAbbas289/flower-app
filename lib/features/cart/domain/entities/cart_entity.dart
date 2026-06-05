import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> cartItems;
  final int totalPrice;
  final int totalPriceAfterDiscount;
  final int discount;
  final int numOfCartItems;

  const CartEntity({
    required this.id,
    required this.cartItems,
    required this.totalPrice,
    required this.totalPriceAfterDiscount,
    required this.discount,
    required this.numOfCartItems,
  });

  @override
  List<Object?> get props => [
        id,
        cartItems,
        totalPrice,
        totalPriceAfterDiscount,
        discount,
        numOfCartItems,
      ];
}
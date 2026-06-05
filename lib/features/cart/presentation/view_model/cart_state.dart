import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

class CartState extends Equatable {
  final BaseState<CartEntity> cartState;
  final BaseState<CartEntity> addToCartState;
  final BaseState<CartEntity> updateQuantityState;
  final BaseState<CartEntity> removeItemState;
  final BaseState<void> clearCartState;

  const CartState({
    this.cartState = const BaseState(),
    this.addToCartState = const BaseState(),
    this.updateQuantityState = const BaseState(),
    this.removeItemState = const BaseState(),
    this.clearCartState = const BaseState(),
  });

  CartState copyWith({
    BaseState<CartEntity>? cartState,
    BaseState<CartEntity>? addToCartState,
    BaseState<CartEntity>? updateQuantityState,
    BaseState<CartEntity>? removeItemState,
    BaseState<void>? clearCartState,
  }) {
    return CartState(
      cartState: cartState ?? this.cartState,
      addToCartState: addToCartState ?? this.addToCartState,
      updateQuantityState: updateQuantityState ?? this.updateQuantityState,
      removeItemState: removeItemState ?? this.removeItemState,
      clearCartState: clearCartState ?? this.clearCartState,
    );
  }

  @override
  List<Object?> get props => [
        cartState,
        addToCartState,
        updateQuantityState,
        removeItemState,
        clearCartState,
      ];
}
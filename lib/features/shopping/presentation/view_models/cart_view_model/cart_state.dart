import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

class CartState extends Equatable {
  final BaseState<CartEntity> cartState;
  final BaseState<CartEntity> addToCartState;
  final BaseState<CartEntity> updateQuantityState;
  final BaseState<CartEntity> removeItemState;
  final BaseState<CartEntity> clearCartState;
  final Map<String, int> localQuantities;

  const CartState({
    this.cartState = const BaseState(),
    this.addToCartState = const BaseState(),
    this.updateQuantityState = const BaseState(),
    this.removeItemState = const BaseState(),
    this.clearCartState = const BaseState(),
    this.localQuantities = const {},
  });

  CartState copyWith({
    BaseState<CartEntity>? cartState,
    BaseState<CartEntity>? addToCartState,
    BaseState<CartEntity>? updateQuantityState,
    BaseState<CartEntity>? removeItemState,
    BaseState<CartEntity>? clearCartState,
    Map<String, int>? localQuantities,
  }) {
    return CartState(
      cartState: cartState ?? this.cartState,
      addToCartState: addToCartState ?? this.addToCartState,
      updateQuantityState: updateQuantityState ?? this.updateQuantityState,
      removeItemState: removeItemState ?? this.removeItemState,
      clearCartState: clearCartState ?? this.clearCartState,
      localQuantities: localQuantities ?? this.localQuantities,
    );
  }

  int getQuantity(String productId, int defaultQuantity) {
    return localQuantities[productId] ?? defaultQuantity;
  }

  @override
  List<Object?> get props => [
        cartState,
        addToCartState,
        updateQuantityState,
        removeItemState,
        clearCartState,
        localQuantities,
      ];
}
import 'package:flower_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartHelpers {
  static bool isInCart(BuildContext context, String productId) {
    return context.read<CartBloc>().state.cartState.data?.cartItems.any(
          (item) => item.product.id == productId,
        ) ??
        false;
  }

  static void addToCart(BuildContext context, String productId) {
    context.read<CartBloc>().add(
      AddToCartEvent(productId: productId, quantity: 1),
    );
  }

  static void removeFromCart(BuildContext context, String productId) {
    final item = context
        .read<CartBloc>()
        .state
        .cartState
        .data
        ?.cartItems
        .firstWhere((item) => item.product.id == productId);

    if (item != null) {
      context.read<CartBloc>().add(
        RemoveProductfromCart(productId: item.product.id),
      );
    }
  }
}

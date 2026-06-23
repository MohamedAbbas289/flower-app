import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_bloc.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartHelpers {
  bool isInCart(BuildContext context, String productId) {
    return context.read<CartBloc>().state.cartState.data?.cartItems.any(
          (item) => item.product.id == productId,
        ) ??
        false;
  }

  void addToCart(BuildContext context, String productId) {
    context.read<CartBloc>().add(
      AddToCartEvent(
        requestModel: CartRequestModel(productId: productId, quantity: 1),
      ),
    );
  }

  void removeFromCart(BuildContext context, String productId) {
    final item = context
        .read<CartBloc>()
        .state
        .cartState
        .data
        ?.cartItems
        .firstWhere((item) => item.product.id == productId);

    if (item != null) {
      context.read<CartBloc>().add(
        RemoveProductfromCartEvent(productId: item.product.id),
      );
    }
  }
}

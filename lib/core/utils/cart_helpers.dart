import 'package:flower_app/core/reusable_widgets/app_dialog.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_view_model.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartHelpers {
  bool isInCart(BuildContext context, String productId) {
    return context.read<CartViewModel>().state.cartState.data?.cartItems.any(
          (item) => item.product.id == productId,
        ) ??
        false;
  }

  void addToCart(BuildContext context, String productId) {
    context.read<CartViewModel>().doEvent(
      AddToCartEvent(
        requestModel: CartRequestModel(productId: productId, quantity: 1),
      ),
    );
  }

  void removeFromCart(BuildContext context, String productId) {
    final item = context
        .read<CartViewModel>()
        .state
        .cartState
        .data
        ?.cartItems
        .firstWhere((item) => item.product.id == productId);

    if (item != null) {
      context.read<CartViewModel>().doEvent(
        RemoveProductfromCartEvent(productId: item.product.id),
      );
    }
  }

  void removeFromCartWithDialog(BuildContext context, String productId) {
    AppDialog.show(
      context: context,
      title: AppStrings.removeItem,
      description: AppStrings.removeItemConfirmation,
      confirmText: AppStrings.remove,
      cancelText: AppStrings.cancel,
      confirmButtonColor: AppColors.red,
      cancelButtonColor: AppColors.pink,
      onConfirm: () => removeFromCart(context, productId),
    );
  }
}

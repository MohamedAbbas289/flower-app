import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_dialog.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/cart/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flower_app/features/checkout/presentation/model/checkout_arguments.dart';
import 'package:flower_app/features/saved_address/domain/use_cases/saved_address_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = getIt<AuthManager>().isLoggedIn;

    if (!isLoggedIn) {
      return Scaffold(
        appBar: _CartAppBar(numOfItems: 0),
        body: _NotLoggedInView(),
      );
    }

    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.removeItemState != current.removeItemState &&
          current.removeItemState.msg != null,
      listener: (context, state) {
        if (state.removeItemState.msg != null) {
          AppSnackBar.showError(context, state.removeItemState.msg!);
        }
      },
      builder: (context, state) {
        final cartState = state.cartState;

        if (cartState.isLoading && cartState.data == null) {
          return Scaffold(
            appBar: _CartAppBar(numOfItems: 0),
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            ),
          );
        }

        if (cartState.msg != null && cartState.data == null) {
          return Scaffold(
            appBar: _CartAppBar(numOfItems: 0),
            body: Center(
              child: Text(
                cartState.msg!,
                textAlign: TextAlign.center,
                style: TextStyles.bodyRegular14,
              ),
            ),
          );
        }

        final cart = cartState.data;
        if (cart == null || cart.cartItems.isEmpty) {
          return Scaffold(
            appBar: _CartAppBar(numOfItems: 0),
            body: _EmptyCartView(),
          );
        }

        return Scaffold(
          appBar: _CartAppBar(numOfItems: cart.numOfCartItems),
          body: _CartContent(cart: cart),
        );
      },
    );
  }
}

class _CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CartAppBar({required this.numOfItems});

  final int numOfItems;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16.0),
        child: Text(
          '${AppStrings.cart} ($numOfItems ${AppStrings.items})',
          style: TextStyles.bodyRegular18.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _NotLoggedInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.assetsIconsShoppingCart,
            height: 80,
            colorFilter: const ColorFilter.mode(
              AppColors.gray,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.pleaseLoginToViewCart,
            style: TextStyles.bodyRegular16,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutesName.login),
            child: Text(AppStrings.loginButton),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.assetsIconsShoppingCart,
            height: 80,
            colorFilter: const ColorFilter.mode(
              AppColors.gray,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          Text(AppStrings.cartEmpty, style: TextStyles.bodyRegular16),
        ],
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent({required this.cart});

  final CartEntity cart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.assetsIconsLocationOn,
                colorFilter: const ColorFilter.mode(
                  AppColors.black,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Text(AppStrings.deliverTo, style: TextStyles.bodyRegular12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  AppStrings.defaultAddress,
                  style: TextStyles.bodyRegular12.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.pink,
                size: 24,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cart.cartItems.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _CartItemCard(item: cart.cartItems[index]);
            },
          ),
        ),
        _CartSummary(cart: cart),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item});

  final CartItemEntity item;

  void _showDeleteDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      title: AppStrings.removeItem,
      description: AppStrings.removeItemConfirmation,
      confirmText: AppStrings.remove,
      cancelText: AppStrings.cancel,
      confirmButtonColor: AppColors.red,
      cancelButtonColor: AppColors.pink,
      onConfirm: () => context.read<CartBloc>().add(
        RemoveProductfromCartEvent(productId: item.product.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.placeHolder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.product.imgCover,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.title,
                        style: TextStyles.bodyRegular14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showDeleteDialog(context),
                      icon: SvgPicture.asset(
                        Assets.assetsIconsTrash,
                        colorFilter: const ColorFilter.mode(
                          AppColors.red,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  item.product.description,
                  style: TextStyles.bodyRegular12.copyWith(
                    color: AppColors.gray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.priceText(item.price),
                      style: TextStyles.bodyRegular14.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _QuantityControl(item: item),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({required this.item});

  final CartItemEntity item;

  void _showDeleteDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      title: AppStrings.removeItem,
      description: AppStrings.removeItemConfirmation,
      confirmText: AppStrings.remove,
      cancelText: AppStrings.cancel,
      confirmButtonColor: AppColors.red,
      cancelButtonColor: AppColors.pink,
      onConfirm: () => context.read<CartBloc>().add(
        RemoveProductfromCartEvent(productId: item.product.id),
      ),
      onCancel: () => context.read<CartBloc>()
        ..add(UpdateLocalQuantityEvent(requestModel: CartRequestModel(productId: item.product.id, quantity: 1)))
        ..add(UpdateQuantityEvent(requestModel: CartRequestModel(productId: item.product.id, quantity: 1))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (prev, curr) =>
          prev.localQuantities[item.product.id] !=
          curr.localQuantities[item.product.id],
      builder: (context, state) {
        final quantity = state.getQuantity(item.product.id, item.quantity);
        return Row(
          children: [
            _QuantityButton(
              icon: Icons.remove,
              onPressed: () {
                if (quantity == 1) {
                  _showDeleteDialog(context);
                } else {
                  context.read<CartBloc>()
                    ..add(
                      UpdateLocalQuantityEvent(
                        requestModel: CartRequestModel(
                          productId: item.product.id,
                          quantity: quantity - 1,
                        ),
                      ),
                    )
                    ..add(
                      UpdateQuantityEvent(
                        requestModel: CartRequestModel(
                          productId: item.product.id,
                          quantity: quantity - 1,
                        ),
                      ),
                    );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '$quantity',
                style: TextStyles.bodyRegular14.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _QuantityButton(
              icon: Icons.add,
              onPressed: () => context.read<CartBloc>()
                ..add(
                  UpdateLocalQuantityEvent(
                    requestModel: CartRequestModel(
                      productId: item.product.id,
                      quantity: quantity + 1,
                    ),
                  ),
                )
                ..add(
                  UpdateQuantityEvent(
                    requestModel: CartRequestModel(
                      productId: item.product.id,
                      quantity: quantity + 1,
                    ),
                  ),
                ),
            ),
          ],
        );
      },
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.cart});

  final CartEntity cart;

  Future<void> _onCheckout(BuildContext context) async {
    final response = await getIt<GetAddressesUseCase>()();

    if (!context.mounted) return;

    switch (response) {
      case SuccessBaseResponse():
        if (response.data.isEmpty) {
          AppSnackBar.showError(context, AppStrings.addAddressBeforeCheckout);
          Navigator.pushNamed(context, AppRoutesName.addAddress);
          return;
        }
        Navigator.pushNamed(
          context,
          AppRoutesName.checkout,
          arguments: CheckoutArguments(
            subTotal: cart.totalPrice,
            deliveryFee: 0,
            total: cart.totalPriceAfterDiscount,
          ),
        );
      case ErrorBaseResponse():
        AppSnackBar.showError(context, AppStrings.addAddressBeforeCheckout);
        Navigator.pushNamed(context, AppRoutesName.addAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.placeHolder)),
      ),
      child: Column(
        children: [
          _SummaryRow(
            title: AppStrings.subTotal,
            value: AppStrings.priceText(cart.totalPrice),
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            title: AppStrings.deliveryFee,
            value: AppStrings.priceText(0),
          ),
          const Divider(height: 24),
          _SummaryRow(
            title: AppStrings.total,
            value: AppStrings.priceText(cart.totalPriceAfterDiscount),
            isBold: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _onCheckout(context),
              child: Text(AppStrings.checkout),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.title,
    required this.value,
    this.isBold = false,
  });

  final String title;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? TextStyles.bodyRegular16.copyWith(fontWeight: FontWeight.w700)
        : TextStyles.bodyRegular14;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(value, style: style),
      ],
    );
  }
}

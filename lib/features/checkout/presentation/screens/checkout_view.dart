import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/checkout/presentation/model/checkout_arguments.dart';
import 'package:flower_app/features/checkout/presentation/view_model/cubit/checkout_view_model.dart';
import 'package:flower_app/features/checkout/presentation/view_model/states/checkout_events.dart';
import 'package:flower_app/features/checkout/presentation/view_model/states/checkout_states.dart';
import 'package:flower_app/features/checkout/presentation/widgets/address_selection_section.dart';
import 'package:flower_app/features/checkout/presentation/widgets/delivery_time_section.dart';
import 'package:flower_app/features/checkout/presentation/widgets/gift_section.dart';
import 'package:flower_app/features/checkout/presentation/widgets/order_summary_section.dart';
import 'package:flower_app/features/checkout/presentation/widgets/payment_method_section.dart';
import 'package:flower_app/features/profile/presentation/widgets/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutView extends StatelessWidget {
  final CheckoutArguments arguments;

  const CheckoutView({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CheckoutViewModel>()..doEvent(const LoadCheckoutDataEvent()),
      child: _CheckoutBody(arguments: arguments),
    );
  }
}

class _CheckoutBody extends StatefulWidget {
  final CheckoutArguments arguments;

  const _CheckoutBody({required this.arguments});

  @override
  State<_CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<_CheckoutBody> {
  final _formKey = GlobalKey<FormState>();
  final _giftNameController = TextEditingController();
  final _giftPhoneController = TextEditingController();

  @override
  void dispose() {
    _giftNameController.dispose();
    _giftPhoneController.dispose();
    super.dispose();
  }

  void _onPlaceOrder(BuildContext context, CheckoutStates state) {
    if (state.isGift && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<CheckoutViewModel>().doEvent(
      PlaceOrderEvent(
        giftName: state.isGift ? _giftNameController.text.trim() : null,
        giftPhone: state.isGift ? _giftPhoneController.text.trim() : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutViewModel, CheckoutStates>(
      listenWhen: (previous, current) =>
          previous.placeOrderState != current.placeOrderState,
      listener: (context, state) async {
        final placeOrderState = state.placeOrderState;
        if (placeOrderState.msg != null) {
          AppSnackBar.showError(context, placeOrderState.msg!);
          return;
        }

        final result = placeOrderState.data;
        if (result == null) return;

        switch (result) {
          case CashOrderPlaced():
            AppSnackBar.showSuccess(
              context,
              AppStrings.orderPlacedSuccessfully,
            );
            Navigator.popUntil(context, (route) => route.isFirst);
          case StripeSessionCreated():
            final isSuccess = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => WebViewScreen(
                  url: result.sessionUrl,
                  title: AppStrings.payment,
                  successUrlPrefix: '${Endpoints.stripeRedirectUrl}/allOrders',
                  cancelUrlPrefix: '${Endpoints.stripeRedirectUrl}/cart',
                ),
              ),
            );

            if (isSuccess == true && context.mounted) {
              getIt<CartBloc>().add(const ClearCartEvent());
              AppSnackBar.showSuccess(
                context,
                AppStrings.orderPlacedSuccessfully,
              );
              Navigator.popUntil(context, (route) => route.isFirst);
            }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(AppStrings.checkout)),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const DeliveryTimeSection(),
                const SizedBox(height: 24),
                AddressSelectionSection(
                  addressesState: state.addressesState,
                  selectedAddress: state.selectedAddress,
                ),
                const SizedBox(height: 24),
                PaymentMethodSection(selected: state.paymentMethod),
                const SizedBox(height: 24),
                GiftSection(
                  isGift: state.isGift,
                  nameController: _giftNameController,
                  phoneController: _giftPhoneController,
                ),
                const SizedBox(height: 24),
                OrderSummarySection(
                  arguments: widget.arguments,
                  isLoading: state.placeOrderState.isLoading,
                  canPlaceOrder: state.selectedAddress != null,
                  onPlaceOrder: () => _onPlaceOrder(context, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

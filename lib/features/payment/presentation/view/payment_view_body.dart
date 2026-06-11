import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_cubit.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_state.dart';
import 'package:flower_app/features/payment/presentation/widgets/payment_listener.dart';
import 'package:flower_app/features/payment/presentation/widgets/payment_step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentViewBody extends StatefulWidget {
  final PaymentRequestModel requestModel;
  final double subTotal;
  final double deliveryFee;
  final double total;

  const PaymentViewBody({
    super.key,
    required this.requestModel,
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  State<PaymentViewBody> createState() => _PaymentViewBodyState();
}

class _PaymentViewBodyState extends State<PaymentViewBody> {
  String _selectedMethod = AppStrings.cash;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: PaymentListener.onStateChange,
      builder: (context, state) {
        final isLoading =
            state.cashOrderState.isLoading ||
            state.checkoutSessionState.isLoading;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentStepHeader(currentStep: 2),
                  const SizedBox(height: 32),
                  Text(
                    AppStrings.paymentMehtod,
                    style: TextStyles.bodyRegular16.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PaymentMethodCard(
                    title: AppStrings.cashOnDelivery,
                    isSelected: _selectedMethod == AppStrings.cash,
                    onTap: () =>
                        setState(() => _selectedMethod = AppStrings.cash),
                  ),
                  const SizedBox(height: 12),
                  _PaymentMethodCard(
                    title: AppStrings.creditCard,
                    isSelected: _selectedMethod == AppStrings.credit,
                    onTap: () =>
                        setState(() => _selectedMethod = AppStrings.credit),
                  ),
                  const SizedBox(height: 40),
                  _SummaryRow(
                    label: AppStrings.subTotal,
                    value: '${widget.subTotal.toStringAsFixed(2)}\$',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: AppStrings.deliveryFee,
                    value: '${widget.deliveryFee.toStringAsFixed(2)}\$',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: AppColors.gray, thickness: 1),
                  ),
                  _SummaryRow(
                    label: AppStrings.total,
                    value: '${widget.total.toStringAsFixed(2)}\$',
                    isTotal: true,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _PlaceOrderButton(
                isLoading: isLoading,
                onPressed: () {
                  if (_selectedMethod == AppStrings.cash) {
                    context.read<PaymentCubit>().createCashOrder(
                      requestModel: widget.requestModel,
                    );
                  } else {
                    context.read<PaymentCubit>().createCheckoutSession(
                      requestModel: widget.requestModel,
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.pink
                : AppColors.gray.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyles.bodyRegular14.copyWith(
                color: AppColors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            _RadioIndicator(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.pink : AppColors.gray,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.pink,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? TextStyles.bodyRegular16.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          )
        : TextStyles.bodyRegular14.copyWith(color: AppColors.gray);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

class _PlaceOrderButton extends StatelessWidget {
  const _PlaceOrderButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                AppStrings.placeOrder,
                style: TextStyles.bodyRegular16.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

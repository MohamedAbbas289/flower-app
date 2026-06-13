import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/checkout/presentation/model/checkout_arguments.dart';
import 'package:flutter/material.dart';

class OrderSummarySection extends StatelessWidget {
  final CheckoutArguments arguments;
  final bool isLoading;
  final bool canPlaceOrder;
  final VoidCallback onPlaceOrder;

  const OrderSummarySection({
    super.key,
    required this.arguments,
    required this.isLoading,
    required this.canPlaceOrder,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(
          title: AppStrings.subTotal,
          value: AppStrings.priceText(arguments.subTotal),
        ),
        const SizedBox(height: 8),
        _SummaryRow(
          title: AppStrings.deliveryFee,
          value: AppStrings.priceText(arguments.deliveryFee),
        ),
        const Divider(height: 24),
        _SummaryRow(
          title: AppStrings.total,
          value: AppStrings.priceText(arguments.total),
          isBold: true,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: (canPlaceOrder && !isLoading) ? onPlaceOrder : null,
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : Text(AppStrings.placeOrder),
          ),
        ),
      ],
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

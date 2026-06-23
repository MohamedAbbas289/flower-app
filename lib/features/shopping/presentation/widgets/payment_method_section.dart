import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/shopping/domain/entities/payment_method.dart';
import 'package:flower_app/features/shopping/presentation/view_models/checkout_view_model/checkout_view_model.dart';
import 'package:flower_app/features/shopping/presentation/view_models/checkout_view_model/checkout_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodSection extends StatelessWidget {
  final PaymentMethod selected;

  const PaymentMethodSection({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.paymentMethod,
          style: TextStyles.bodyRegular16.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        RadioGroup<PaymentMethod>(
          groupValue: selected,
          onChanged: (method) {
            if (method != null) {
              context.read<CheckoutViewModel>().doEvent(
                SelectPaymentMethodEvent(method),
              );
            }
          },
          child: Column(
            children: [
              _PaymentMethodTile(
                title: AppStrings.cashOnDelivery,
                value: PaymentMethod.cash,
                selected: selected,
                onSelect: () => context.read<CheckoutViewModel>().doEvent(
                  const SelectPaymentMethodEvent(PaymentMethod.cash),
                ),
              ),
              const SizedBox(height: 8),
              _PaymentMethodTile(
                title: AppStrings.creditCard,
                value: PaymentMethod.card,
                selected: selected,
                onSelect: () => context.read<CheckoutViewModel>().doEvent(
                  const SelectPaymentMethodEvent(PaymentMethod.card),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final PaymentMethod value;
  final PaymentMethod selected;
  final VoidCallback onSelect;

  const _PaymentMethodTile({
    required this.title,
    required this.value,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.pink : AppColors.lightPink,
          ),
        ),
        child: Row(
          children: [
            Radio<PaymentMethod>(value: value, activeColor: AppColors.pink),
            Text(title, style: TextStyles.bodyRegular14),
          ],
        ),
      ),
    );
  }
}

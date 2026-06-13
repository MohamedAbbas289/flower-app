import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/validation/app_regex.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/checkout/presentation/view_model/cubit/checkout_view_model.dart';
import 'package:flower_app/features/checkout/presentation/view_model/states/checkout_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiftSection extends StatelessWidget {
  final bool isGift;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  const GiftSection({
    super.key,
    required this.isGift,
    required this.nameController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.isGift,
              style: TextStyles.bodyRegular16.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Switch(
              value: isGift,
              activeThumbColor: AppColors.pink,
              onChanged: (value) => context.read<CheckoutViewModel>().doEvent(
                ToggleGiftEvent(value),
              ),
            ),
          ],
        ),
        if (isGift) ...[
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppStrings.enterTheRecipientName;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: AppStrings.recipientName,
              hintText: AppStrings.enterTheRecipientName,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppStrings.enterThePhoneNumber;
              }
              if (!AppRegex.isValidPhoneNumber(value)) {
                return AppStrings.phoneInvalid;
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: AppStrings.phoneNumber,
              hintText: AppStrings.enterThePhoneNumber,
            ),
          ),
        ],
      ],
    );
  }
}

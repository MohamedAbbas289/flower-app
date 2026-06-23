import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeliveryTimeSection extends StatelessWidget {
  const DeliveryTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightPink),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.assetsIconsSchedule,
            colorFilter: const ColorFilter.mode(
              AppColors.pink,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.deliveryTime,
                  style: TextStyles.bodyRegular14.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.estimatedDeliveryTime,
                  style: TextStyles.bodyRegular12.copyWith(
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            AppStrings.schedule,
            style: TextStyles.bodyRegular14.copyWith(
              color: AppColors.pink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

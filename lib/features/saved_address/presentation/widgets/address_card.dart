import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressCard extends StatelessWidget {
  final AddressEntity address;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const AddressCard({
    super.key,
    required this.address,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightPink),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.assetsIconsLocationOn,
                        colorFilter: const ColorFilter.mode(
                          AppColors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),

                      Text(
                        address.city ?? '',
                        style: TextStyles.bodyRegular14.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.street ?? '',
                    style: TextStyles.bodyRegular14.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: SvgPicture.asset(
              Assets.assetsIconsDelete,
              colorFilter: const ColorFilter.mode(
                AppColors.red,
                BlendMode.srcIn,
              ),
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: SvgPicture.asset(Assets.assetsIconsEidtPen),
          ),
        ],
      ),
    );
  }
}

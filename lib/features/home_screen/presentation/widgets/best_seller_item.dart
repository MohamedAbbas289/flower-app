import 'package:flower_app/core/reusable_widgets/product_image.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class BestSellerItem extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final VoidCallback onTap;
  final int price;

  const BestSellerItem({
    required this.id,
    required this.name,
    required this.image,
    required this.onTap,
    required this.price,
    super.key,
  });

  static const double _cardWidth = 131;
  static const double _imageHeight = 151;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: _cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _imageHeight,
              width: _cardWidth,
              child: ProductImage(
                imageUrl: image,
                devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
                size: MediaQuery.sizeOf(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.bodyRegular12.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            Text(
              AppStrings.priceText(price),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.bodyRegular14,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flower_app/core/reusable_widgets/product_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final VoidCallback onTap;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.image,
    required this.onTap,
    super.key,
  });

  static const double _containerSize = 68;
  static const double _cardWidth = 80;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: _cardWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _containerSize,
              height: _containerSize,
              decoration: BoxDecoration(
                color: AppColors.lightPink,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              padding: const EdgeInsets.all(12),
              child: ProductImage(
                imageUrl: image,
                devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
                size: MediaQuery.sizeOf(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyles.bodyRegular12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
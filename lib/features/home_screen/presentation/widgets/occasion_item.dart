import 'package:flower_app/core/reusable_widgets/product_image.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/values/endpoints.dart';

class OccasionItem extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final VoidCallback onTap;

  const OccasionItem({
    required this.id,
    required this.name,
    required this.image,
    required this.onTap,
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
                imageUrl: '${Endpoints.imageBaseUrl}$image',
                heroTag: AppStrings.productImageHeroTag(id),
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
            ),
          ],
        ),
      ),
    );
  }
}

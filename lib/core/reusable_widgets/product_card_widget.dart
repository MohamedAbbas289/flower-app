import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/entities/product_card_data.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/app_responsive.dart';
import 'package:flower_app/core/utils/responsive_text_style.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({super.key, required this.product, this.onAddToCart});

  final ProductCardData? product;
  final VoidCallback? onAddToCart;

  static final _skeleton = _SkeletonProduct();

  @override
  Widget build(BuildContext context) {
    final isLoading = product == null;
    final data = product ?? _skeleton;

    return Skeletonizer(
      enabled: isLoading,
      effect: ShimmerEffect(
        baseColor: AppColors.placeHolder.withAlpha(102),
        highlightColor: Colors.white.withAlpha(204),
      ),
      child: _ProductCardContent(
        product: data,
        onAddToCart: isLoading ? null : onAddToCart,
      ),
    );
  }
}

final class _SkeletonProduct implements ProductCardData {
  @override
  String get id => 'skeleton';
  @override
  String get name => 'Product name';
  @override
  String get imageUrl => '';
  @override
  int get price => 300;
  @override
  int? get originalPrice => 400;
  @override
  int? get discountPercent => 60;
}

class _ProductCardContent extends StatelessWidget {
  const _ProductCardContent({required this.product, this.onAddToCart});

  final ProductCardData product;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.placeHolder, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1 / 0.78,
            child: _ProductImage(
              imageUrl: product.imageUrl,
              heroTag: 'product-image-${product.id}',
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _ProductInfo(product: product),
          ),
          const SizedBox(height: 8),
          _AddToCartButton(onPressed: onAddToCart),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl, required this.heroTag});

  final String imageUrl;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 300),
          placeholder: (context, url) => const _ImagePlaceholder(),
          errorWidget: (context, url, error) => const _ImageError(),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.placeHolder.withAlpha(77),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.placeHolder.withAlpha(51),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 28,
            color: AppColors.gray,
          ),
          SizedBox(height: 4),
          Text(
            AppStrings.imageNotAvailable,
            style: TextStyle(fontSize: 10, color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product});
  final ProductCardData product;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyles.bodyRegular12.responsive(
            size,
            mobile: 12,
            landscape: 10,
            tablet: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        _PriceRow(product: product),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product});

  final ProductCardData product;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        children: [
          Text(
            'EGP ${product.price}',
            style: TextStyles.bodyRegular14
                .responsive(size, mobile: 14, landscape: 11, tablet: 15)
                .copyWith(fontWeight: FontWeight.w600),
          ),

          if (product.originalPrice != null &&
              product.discountPercent != null &&
              product.discountPercent! > 0) ...[
            const SizedBox(width: 6),

            Text(
              '${product.originalPrice}',
              style: TextStyles.bodyRegular12
                  .responsive(size, mobile: 12, landscape: 9, tablet: 13)
                  .copyWith(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.grey,
                  ),
            ),

            const SizedBox(width: 4),

            Text(
              '${product.discountPercent}%',
              style: TextStyles.bodyRegular12
                  .responsive(size, mobile: 12, landscape: 9, tablet: 13)
                  .copyWith(
                    color: AppColors.green,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isLandscape = AppResponsive.isMobileLandscape(size);

    return SizedBox(
      width: double.infinity,
      height: isLandscape ? 34 : 38,
      child: FilledButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.assetsIconsShoppingCart,
              height: isLandscape ? 16 : 18,
              width: isLandscape ? 16 : 18,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                AppStrings.addToCart,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.buttonTextStyle.responsive(
                  size,
                  mobile: 13,
                  landscape: 10,
                  tablet: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

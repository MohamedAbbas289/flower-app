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
    final size = MediaQuery.sizeOf(context);
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    return Skeletonizer(
      enabled: isLoading,
      effect: ShimmerEffect(
        baseColor: AppColors.placeHolder.withAlpha(102),
        highlightColor: AppColors.white.withAlpha(204),
      ),
      child: _ProductCardContent(
        size: size,
        devicePixelRatio: devicePixelRatio,
        product: data,
        onAddToCart: isLoading ? null : onAddToCart,
        enableHero: !isLoading,
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
  const _ProductCardContent({
    required this.product,
    required this.size,
    required this.devicePixelRatio,
    this.onAddToCart,
    this.enableHero = true,
  });

  final ProductCardData product;
  final VoidCallback? onAddToCart;
  final bool enableHero;
  final Size size;
  final double devicePixelRatio;
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
              size: size,
              devicePixelRatio: devicePixelRatio,
              imageUrl: product.imageUrl,
              heroTag: enableHero ? 'product-image-${product.id}' : null,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _ProductInfo(product: product, size: size),
          ),
          const SizedBox(height: 8),
          _AddToCartButton(onPressed: onAddToCart, size: size),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.imageUrl,
    this.heroTag,
    required this.size,
    required this.devicePixelRatio,
  });

  final String imageUrl;
  final String? heroTag;
  final Size size;
  final double devicePixelRatio;
  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
        memCacheWidth: AppResponsive.cardCacheWidth(size, devicePixelRatio),
        placeholder: (context, url) => const _ImagePlaceholder(),
        errorWidget: (context, url, error) => _ImageError(imageUrl: imageUrl),
      ),
    );

    if (heroTag == null) return image;

    return Hero(tag: heroTag!, child: image);
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

class _ImageError extends StatefulWidget {
  const _ImageError({required this.imageUrl});
  final String imageUrl;

  @override
  State<_ImageError> createState() => _ImageErrorState();
}

class _ImageErrorState extends State<_ImageError> {
  int _retryKey = 0;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: ValueKey(_retryKey), // ← بيتغير عشان يعمل retry
      imageUrl: widget.imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => const _ImagePlaceholder(),
      errorWidget: (context, url, error) => Container(
        width: double.infinity,
        color: AppColors.placeHolder.withAlpha(51),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_not_supported_outlined,
              size: 28,
              color: AppColors.gray,
            ),
            const SizedBox(height: 4),
            const Text(
              AppStrings.imageNotAvailable,
              style: TextStyle(fontSize: 10, color: AppColors.gray),
            ),
            const SizedBox(height: 6),
            IconButton(
              onPressed: () => setState(() => _retryKey++),
              icon: const Icon(Icons.refresh, color: AppColors.gray),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product, required this.size});
  final ProductCardData product;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: TextStyles.bodyRegular12.responsive(
            size,
            mobile: 12,
            tablet: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        _PriceRow(product: product, size: size),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product, required this.size});

  final ProductCardData product;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        children: [
          Text(
            'EGP ${product.price}',
            style: TextStyles.bodyRegular14
                .responsive(size, mobile: 14, tablet: 15)
                .copyWith(fontWeight: FontWeight.w600),
          ),

          if (product.originalPrice != null &&
              product.discountPercent != null &&
              product.discountPercent! > 0) ...[
            const SizedBox(width: 6),

            Text(
              '${product.originalPrice}',
              style: TextStyles.bodyRegular12
                  .responsive(size, mobile: 12, tablet: 13)
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
                  .responsive(size, mobile: 12, tablet: 13)
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
  const _AddToCartButton({this.onPressed, required this.size});

  final VoidCallback? onPressed;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: FilledButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.assetsIconsShoppingCart,
              height: 18,
              width: 18,
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

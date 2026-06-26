import 'package:flower_app/core/entities/product_card_data.dart';
import 'package:flower_app/core/reusable_widgets/product_image.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    required this.product,
    required this.isInCart,
    this.onAddToCart,
    this.onRemoveFromCart,
    this.heroTag,
  });

  final ProductCardData product;
  final bool isInCart;
  final void Function(String productId)? onAddToCart;
  final void Function(String productId)? onRemoveFromCart;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return _ProductCardContent(
      size: size,
      devicePixelRatio: devicePixelRatio,
      product: product,
      isInCart: isInCart,
      onAddToCart: onAddToCart,
      onRemoveFromCart: onRemoveFromCart,
      heroTag: heroTag,
    );
  }
}

class _ProductCardContent extends StatelessWidget {
  const _ProductCardContent({
    required this.product,
    required this.size,
    required this.devicePixelRatio,
    required this.isInCart,
    this.onAddToCart,
    this.onRemoveFromCart,
    this.heroTag,
  });

  final String? heroTag;
  final ProductCardData product;
  final bool isInCart;
  final void Function(String productId)? onAddToCart;
  final void Function(String productId)? onRemoveFromCart;
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
            aspectRatio: 1 / 0.76,
            child: ProductImage(
              size: size,
              devicePixelRatio: devicePixelRatio,
              imageUrl: product.imageUrl,
              heroTag: heroTag,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _ProductInfo(product: product, size: size),
          ),
          Spacer(),
          _AddToCartButton(
            size: size,
            isInCart: isInCart,
            availableQuantity: product.availableQuantity,
            onAddToCart: onAddToCart != null
                ? () => onAddToCart!(product.id)
                : null,
            onRemoveFromCart: onRemoveFromCart != null
                ? () => onRemoveFromCart!(product.id)
                : null,
          ),
        ],
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
          style: TextStyles.bodyRegular12,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
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
            AppStrings.priceText(product.price),
            style: TextStyles.bodyRegular14.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (product.originalPrice != null &&
              product.discountPercent != null &&
              product.discountPercent! > 0) ...[
            const SizedBox(width: 6),
            Text(
              '${product.originalPrice}',
              style: TextStyles.bodyRegular12.copyWith(
                color: AppColors.gray,
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColors.gray,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${product.discountPercent}%',
              style: TextStyles.bodyRegular12.copyWith(
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
  const _AddToCartButton({
    required this.size,
    required this.isInCart,
    this.availableQuantity,
    this.onAddToCart,
    this.onRemoveFromCart,
  });

  final Size size;
  final bool isInCart;
  final int? availableQuantity;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRemoveFromCart;

  bool get _isOutOfStock =>
      availableQuantity != null && availableQuantity! <= 0;

  @override
  Widget build(BuildContext context) {
    if (_isOutOfStock && !isInCart) {
      return SizedBox(
        width: double.infinity,
        height: 30,
        child: FilledButton(
          onPressed: null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.gray,
            disabledBackgroundColor: AppColors.gray,
          ),
          child: Text(
            AppStrings.outOfStock,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyles.buttonTextStyle,
          ),
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        key: ValueKey(isInCart),
        width: double.infinity,
        height: 30,
        child: FilledButton(
          onPressed: isInCart ? onRemoveFromCart : onAddToCart,
          style: FilledButton.styleFrom(
            backgroundColor: isInCart ? AppColors.red : AppColors.pink,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isInCart
                    ? Assets.assetsIconsTrash
                    : Assets.assetsIconsShoppingCart,
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
                  isInCart ? AppStrings.remove : AppStrings.addToCart,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyles.buttonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

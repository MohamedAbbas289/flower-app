import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/cart_helpers.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_bloc.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_state.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_cubit.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_events.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key, required this.productId});
  final String productId;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsCubit>().doEvent(
      GetProductDetailsEvent(productId: widget.productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsBaseState>(
      listener: (context, state) {
        if (!state.productDetailsState.isLoading &&
            state.productDetailsState.data == null) {
          AppSnackBar.showError(
            context,
            state.productDetailsState.msg!,
            icon: SvgPicture.asset(
              Assets.assetsIconsError,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          );
        }
      },
      child: _ProductDetailsScaffold(productId: widget.productId),
    );
  }
}

class _ProductDetailsScaffold extends StatelessWidget {
  const _ProductDetailsScaffold({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsBaseState>(
        builder: (context, state) {
          if (state.productDetailsState.isLoading == true) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            );
          }

          if (state.productDetailsState.data != null) {
            return _ProductDetailsBody(
              entity: state.productDetailsState.data!,
              productId: productId,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: _AddToCartButton(productId: productId),
    );
  }
}

class _ProductDetailsBody extends StatelessWidget {
  const _ProductDetailsBody({required this.entity, required this.productId});

  final ProductDetailsEntity entity;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageSlider(entity: entity, productId: productId),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _PriceAndStatus(entity: entity),
                const SizedBox(height: 8),
                _ProductTitle(title: entity.title),
                const SizedBox(height: 20),
                _DescriptionSection(description: entity.description),
                const SizedBox(height: 26),
                _BouquetIncludeSection(entity: entity),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageSlider extends StatefulWidget {
  const _ImageSlider({required this.entity, required this.productId});

  final ProductDetailsEntity entity;
  final String productId;

  @override
  State<_ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<_ImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 450,
          child: PageView.builder(
            itemCount: widget.entity.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final imageWidget = CachedNetworkImage(
                imageUrl: widget.entity.images[index],
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
                memCacheWidth: 600,
                placeholder: (_, _) => const Center(
                  child: CircularProgressIndicator(color: AppColors.pink),
                ),
                errorWidget: (_, _, _) =>
                    const Icon(Icons.broken_image, color: AppColors.gray),
              );
              // ToDo: eng.Loay
              if (index == 0) {
                return Hero(
                  tag: AppStrings.productImageHeroTag(widget.productId),
                  child: imageWidget,
                );
              }
              return imageWidget;
            },
          ),
        ),
        Positioned(top: 40, left: 8, child: _BackButton()),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: _DotsIndicator(
            count: widget.entity.images.length,
            currentIndex: _currentIndex,
          ),
        ),
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: SvgPicture.asset(
        Assets.assetsIconsArrowBack,
        colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentIndex ? 10 : 8,
          height: index == currentIndex ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex ? AppColors.pink : AppColors.gray,
          ),
        ),
      ),
    );
  }
}

class _PriceAndStatus extends StatelessWidget {
  const _PriceAndStatus({required this.entity});

  final ProductDetailsEntity entity;

  @override
  Widget build(BuildContext context) {
    final isInStock = entity.quantity > 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EGP ${entity.priceAfterDiscount}',
              style: TextStyles.appBarTextStyle.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
            Text(
              AppStrings.allPricesIncludeTax,
              style: TextStyles.bodyRegular13.copyWith(color: AppColors.gray),
            ),
          ],
        ),
        Row(
          children: [
            Text('${AppStrings.status} ', style: TextStyles.bodyRegular16),
            Text(
              isInStock ? AppStrings.inStock : AppStrings.outOfStock,
              style: TextStyles.bodyRegular16.copyWith(
                color: isInStock ? AppColors.green : AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductTitle extends StatelessWidget {
  const _ProductTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyles.bodyRegular16.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.description,
          style: TextStyles.bodyRegular16.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Text(description, style: TextStyles.textFieldTextStyle),
      ],
    );
  }
}

class _BouquetIncludeSection extends StatelessWidget {
  const _BouquetIncludeSection({required this.entity});

  final ProductDetailsEntity entity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.bouquetInclude,
          style: TextStyles.bodyRegular16.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Text(
          '${AppStrings.pinkRoses}: ${entity.quantity}',
          style: TextStyles.bodyRegular13,
        ),
        Text(AppStrings.whiteWrap, style: TextStyles.bodyRegular13),
      ],
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  const _AddToCartButton({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, bool>(
      selector: (state) =>
          state.cartState.data?.cartItems.any(
            (item) => item.product.id == productId,
          ) ??
          false,
      builder: (context, isInCart) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                key: ValueKey(isInCart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInCart ? AppColors.red : AppColors.pink,
                ),
                onPressed: () {
                  if (isInCart) {
                    getIt<CartHelpers>().removeFromCart(context, productId);
                  } else {
                    getIt<CartHelpers>().addToCart(context, productId);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      isInCart
                          ? Assets.assetsIconsTrash
                          : Assets.assetsIconsShoppingCart,
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isInCart ? AppStrings.remove : AppStrings.addToCart,
                      style: TextStyles.buttonTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

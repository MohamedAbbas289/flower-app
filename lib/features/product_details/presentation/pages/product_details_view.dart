import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/product_details/presentation/view_model/product_details_cubit.dart';
import 'package:flower_app/features/product_details/presentation/view_model/product_details_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsBaseState>(
      listenWhen: (_, current) => current is ProductDetailsFailure,
      listener: (context, state) {
        if (state is ProductDetailsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: const _ProductDetailsScaffold(),
    );
  }
}

class _ProductDetailsScaffold extends StatelessWidget {
  const _ProductDetailsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsBaseState>(
        buildWhen: (_, current) =>
            current is ProductDetailsLoading ||
            current is ProductDetailsSuccess ||
            current is ProductDetailsFailure,
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            );
          }

          if (state is ProductDetailsSuccess) {
            return _ProductDetailsBody(entity: state.entity);
          }

          if (state is ProductDetailsFailure) {
            return Center(
              child: Text(state.error, style: TextStyles.errorText),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: const _AddToCartButton(),
    );
  }
}

class _ProductDetailsBody extends StatelessWidget {
  const _ProductDetailsBody({required this.entity});

  final ProductDetailsEntity entity;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageSlider(entity: entity),
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
  const _ImageSlider({required this.entity});

  final ProductDetailsEntity entity;

  @override
  State<_ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<_ImageSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.entity.images.isNotEmpty
        ? widget.entity.images
        : [widget.entity.imgCover];

    return Stack(
      children: [
        SizedBox(
          height: 450,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Hero(
                tag: 'product-${widget.entity.id}-$index',
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                  memCacheWidth: 600,
                  placeholder: (_, _) => const Center(
                    child: CircularProgressIndicator(color: AppColors.pink),
                  ),
                  errorWidget: (_, _, _) =>
                      const Icon(Icons.broken_image, color: AppColors.gray),
                ),
              );
            },
          ),
        ),
        Positioned(top: 40, left: 16, child: _BackButton()),
        Positioned(
          bottom: 12,
          left: 0,
          right: 0,
          child: _DotsIndicator(
            count: images.length,
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
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
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
              'EGP ${entity.price}',
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
  const _AddToCartButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            // TODO: implement add to cart navigation
          },
          child: const Text(AppStrings.addToCart),
        ),
      ),
    );
  }
}

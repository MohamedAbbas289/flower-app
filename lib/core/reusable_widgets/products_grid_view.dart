import 'package:flower_app/core/entities/product_card_data.dart';
import 'package:flower_app/core/reusable_widgets/product_card_widget.dart';
import 'package:flower_app/core/utils/app_responsive.dart';
import 'package:flutter/material.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({
    super.key,
    required this.products,
    required this.onAddToCart,
    this.isLoading = false,
  });

  final List<ProductCardData> products;
  final void Function(String productId) onAddToCart;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final itemCount = isLoading
        ? AppResponsive.gridSkeletonCount(size)
        : products.length;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppResponsive.gridCrossAxisCount(size),
        childAspectRatio: AppResponsive.gridChildAspectRatio(size),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (isLoading) return const ProductCardWidget(product: null);

        final product = products[index];
        return ProductCardWidget(
          product: product,
          onAddToCart: () => onAddToCart(product.id),
        );
      },
    );
  }
}

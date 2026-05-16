import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:flower_app/core/entities/product_card_data.dart';
import 'package:flower_app/core/reusable_widgets/product_card_widget.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/utils/app_responsive.dart';

final class _FakeProduct implements ProductCardData {
  const _FakeProduct();

  @override
  String get id => 'fake';

  @override
  String get name => 'Loading product';

  @override
  String get imageUrl => '';

  @override
  int get price => 0;

  @override
  int? get originalPrice => null;

  @override
  int? get discountPercent => null;
}

class ProductsGridView extends StatefulWidget {
  const ProductsGridView({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onCardClicked,
    required this.currentPage,
    required this.totalPages,
    required this.paginationResetKey,
    this.isLoading = false,
    this.hasError = false,
    this.onLoadMore,
  });

  final List<ProductCardData> products;
  final void Function(String productId) onAddToCart;
  final void Function(String productId) onCardClicked;

  final int currentPage;
  final int totalPages;

  final int paginationResetKey;

  final bool isLoading;
  final bool hasError;
  final VoidCallback? onLoadMore;

  @override
  State<ProductsGridView> createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  final ScrollController _controller = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;

    final position = _controller.position;
    final reachedEnd = position.pixels >= position.maxScrollExtent - 200;
    final hasMorePages = widget.currentPage < widget.totalPages;

    if (reachedEnd && hasMorePages && !_isLoadingMore && !widget.isLoading) {
      setState(() {
        _isLoadingMore = true;
      });
      widget.onLoadMore?.call();
    }
  }

  @override
  void didUpdateWidget(covariant ProductsGridView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final resetPagination =
        oldWidget.paginationResetKey != widget.paginationResetKey;

    final pageChanged = oldWidget.currentPage != widget.currentPage;
    final errorOccurred = !oldWidget.hasError && widget.hasError;

    if (resetPagination || pageChanged || errorOccurred) {
      _isLoadingMore = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final itemCount = widget.isLoading
        ? AppResponsive.gridSkeletonCount(size)
        : widget.products.length + (_isLoadingMore ? 1 : 0);

    return Skeletonizer(
      enabled: widget.isLoading,
      effect: ShimmerEffect(
        baseColor: AppColors.placeHolder.withAlpha(102),
        highlightColor: AppColors.white.withAlpha(204),
      ),
      child: GridView.builder(
        controller: _controller,
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppResponsive.gridCrossAxisCount(size),
          childAspectRatio: AppResponsive.gridChildAspectRatio(size),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (widget.isLoading) {
            return const ProductCardWidget(product: _FakeProduct());
          }

          final isPaginationLoader = index == widget.products.length;

          if (isPaginationLoader) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final product = widget.products[index];

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => widget.onCardClicked(product.id),
            child: ProductCardWidget(
              product: product,
              onAddToCart: () => widget.onAddToCart(product.id),
            ),
          );
        },
      ),
    );
  }
}

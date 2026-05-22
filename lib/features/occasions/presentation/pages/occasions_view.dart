import 'package:flower_app/core/reusable_widgets/app_refresh_indicator.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/reusable_widgets/app_tab_bar_widget.dart';
import 'package:flower_app/core/reusable_widgets/products_grid_view.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_events.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_state.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OccasionsView extends StatefulWidget {
  const OccasionsView({super.key, this.initialOccasionId});

  final String? initialOccasionId;

  @override
  State<OccasionsView> createState() => _OccasionsViewState();
}

class _OccasionsViewState extends State<OccasionsView> {
  @override
  void initState() {
    super.initState();
    context.read<OccasionsViewModel>().doEvent(
      GetOccasionsEvent(initialOccasionId: widget.initialOccasionId),
    );
  }

  Future<void> _onRefresh() async {
    final vm = context.read<OccasionsViewModel>();
    vm.doEvent(RefreshOccasionsEvent());
    await vm.stream.firstWhere(
      (s) => !s.occasionsState.isLoading && !s.productsState.isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const _OccasionsAppBar(),
      body: AppRefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocConsumer<OccasionsViewModel, OccasionsState>(
          listenWhen: (previous, current) =>
              previous.productsState.msg != current.productsState.msg &&
              current.productsState.msg != null &&
              current.productsState.data == null,
          listener: (context, state) {
            AppSnackBar.showError(context, state.productsState.msg!);
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OccasionsTabBar(state: state),
                Expanded(child: _OccasionsBody(state: state)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OccasionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _OccasionsAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.occasionTitle,
            style: TextStyles.bodyRegular16.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          Text(
            AppStrings.occasionSubtitle,
            style: TextStyles.bodyRegular12.copyWith(color: AppColors.gray),
          ),
        ],
      ),
      titleSpacing: 0,
    );
  }
}

class _OccasionsTabBar extends StatelessWidget {
  const _OccasionsTabBar({required this.state});

  final OccasionsState state;

  @override
  Widget build(BuildContext context) {
    final occasionsState = state.occasionsState;

    if (occasionsState.isLoading) {
      return const SizedBox(
        height: 40,
        child: Center(
          child: LinearProgressIndicator(
            color: AppColors.pink,
            backgroundColor: AppColors.placeHolder,
          ),
        ),
      );
    }

    if (occasionsState.msg != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          occasionsState.msg!,
          style: TextStyles.bodyRegular12.copyWith(color: AppColors.red),
        ),
      );
    }

    final occasions = occasionsState.data;
    if (occasions == null || occasions.isEmpty) return const SizedBox.shrink();

    final selectedIndex = occasions.indexWhere(
      (occasion) => occasion.id == state.selectedOccasionId,
    );
    final initialIndex = selectedIndex < 0 ? 0 : selectedIndex;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: AppTabBarWidget(
        tabs: occasions,
        initialIndex: initialIndex,
        isLoadingMore: state.isLoadingMoreOccasions,
        onLoadMore: () {
          context.read<OccasionsViewModel>().doEvent(LoadMoreOccasionsEvent());
        },
        onTabChanged: (tab) {
          context.read<OccasionsViewModel>().doEvent(
            GetProductsByOccasionEvent(occasionId: tab.id),
          );
        },
      ),
    );
  }
}

class _OccasionsBody extends StatelessWidget {
  const _OccasionsBody({required this.state});

  final OccasionsState state;

  @override
  Widget build(BuildContext context) {
    final productsState = state.productsState;

    if (productsState.msg != null && productsState.data == null) {
      return _ErrorView(
        message: productsState.msg!,
        onRetry: () {
          if (state.selectedOccasionId != null) {
            context.read<OccasionsViewModel>().doEvent(
              GetProductsByOccasionEvent(occasionId: state.selectedOccasionId!),
            );
          }
        },
      );
    }

    final products = productsState.data ?? [];

    return ProductsGridView(
      products: products,
      onCardClicked: (productId) {
        Navigator.of(context).pushNamed(
          AppRoutesName.productDetails,
          arguments: productId,
        );
      },
       // ToDo: eng.Loay
      heroTagBuilder: (productId) => AppStrings.productImageHeroTag(productId),
      isLoading: productsState.isLoading && products.isEmpty,
      currentPage: state.currentPage,
      totalPages: state.totalPages,
      paginationResetKey: state.paginationResetKey,
      onLoadMore: () {
        context.read<OccasionsViewModel>().doEvent(LoadMoreProductsEvent());
      },
      onAddToCart: (productId) {
        // TODO add to cart feature
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.gray),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.bodyRegular14.copyWith(color: AppColors.gray),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(AppStrings.retry)),
          ],
        ),
      ),
    );
  }
}
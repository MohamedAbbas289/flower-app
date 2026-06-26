import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/products_grid_view.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/utils/cart_helpers.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_view_model.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_state.dart';
import 'package:flower_app/features/home/presentation/view_models/search_view_model/search_states.dart';
import 'package:flower_app/features/home/presentation/view_models/search_view_model/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchViewModel>(),
      child: BlocProvider.value(
        value: getIt<CartViewModel>(),
        child: const _SearchView(),
      ),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String query) {
    context.read<SearchViewModel>().onSearchSubmitted(query);
  }

  void _onChanged(String query) {
    context.read<SearchViewModel>().onQueryChanged(query);
  }

  void _onClear() {
    _controller.clear();
    context.read<SearchViewModel>().onClearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _SearchBar(
              controller: _controller,
              onSubmitted: _onSubmitted,
              onChanged: _onChanged,
              onClear: _onClear,
            ),
            const SizedBox(height: 12),
            const Expanded(child: _SearchBody()),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.controller,
    required this.onSubmitted,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final void Function(String query) onSubmitted;
  final void Function(String query) onChanged;
  final VoidCallback onClear;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 48,
        child: TextField(
          controller: widget.controller,
          textInputAction: TextInputAction.search,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: AppStrings.search,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                Assets.assetsIconsSearch,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray,
                  BlendMode.srcIn,
                ),
              ),
            ),
            suffixIcon: _hasText
                ? IconButton(
                    icon: const Icon(Icons.close, color: AppColors.gray),
                    onPressed: widget.onClear,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.placeHolder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.placeHolder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.pink),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchViewModel, SearchState>(
      builder: (context, state) {
        if (state.isInitial) {
          return _SearchInitialState(message: AppStrings.searchForAnyProduct);
        }

        final ps = state.productsState;

        if (ps.isLoading) {
          return ProductsGridView(
            products: const [],
            isInCart: (_) => false,
            onAddToCart: (_) {},
            onRemoveFromCart: (_) {},
            onCardClicked: (_) {},
            currentPage: 1,
            totalPages: 1,
            paginationResetKey: 0,
            isLoading: true,
          );
        }

        if (ps.msg != null) {
          return _SearchErrorState(message: ps.msg!);
        }

        final products = ps.data ?? [];

        if (products.isEmpty) {
          return _SearchErrorState(message: AppStrings.noProductsAvailable);
        }

        return BlocBuilder<CartViewModel, CartState>(
          buildWhen: (prev, curr) => prev.cartState != curr.cartState,
          builder: (context, cartState) {
            return ProductsGridView(
              products: products,
              isInCart: (productId) =>
                  getIt<CartHelpers>().isInCart(context, productId),
              onAddToCart: (productId) =>
                  getIt<CartHelpers>().addToCart(context, productId),
              onRemoveFromCart: (productId) =>
                  getIt<CartHelpers>().removeFromCartWithDialog(context, productId),
              onCardClicked: (productId) {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutesName.productDetails, arguments: productId);
              },
              heroTagBuilder: (productId) =>
                  AppStrings.productImageHeroTag(productId),
              currentPage: 1,
              totalPages: 1,
              paginationResetKey: 0,
            );
          },
        );
      },
    );
  }
}

class _SearchInitialState extends StatelessWidget {
  const _SearchInitialState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyles.bodyRegular14.copyWith(color: AppColors.pink),
        ),
      ),
    );
  }
}

class _SearchErrorState extends StatelessWidget {
  const _SearchErrorState({required this.message});

  final String message;

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
          ],
        ),
      ),
    );
  }
}

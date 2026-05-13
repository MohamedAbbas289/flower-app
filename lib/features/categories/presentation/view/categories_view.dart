import 'package:flower_app/core/entities/tab_item_data.dart';
import 'package:flower_app/core/reusable_widgets/app_refresh_indicator.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/reusable_widgets/app_tab_bar_widget.dart';
import 'package:flower_app/core/reusable_widgets/products_grid_view.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/categories/presentation/view/categories_filter_bottom_sheet.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_events.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_states.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  bool _showFab = true;

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CategoriesFilterBottomSheet(),
    );
  }

  Future<void> _onRefresh() async {
    final vm = context.read<CategoriesViewModel>();
    vm.doEvent(const RefreshEvent());
    await vm.stream.firstWhere((s) => !s.productsState.isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<CategoriesViewModel, CategoriesState>(
          listenWhen: (prev, curr) =>
              prev.productsState != curr.productsState &&
              curr.productsState.msg != null,
          listener: (context, state) {
            AppSnackBar.showError(context, state.productsState.msg!);
          },
          child: NotificationListener<UserScrollNotification>(
            onNotification: (n) {
              if (n.direction == ScrollDirection.forward && !_showFab) {
                setState(() => _showFab = true);
              } else if (n.direction == ScrollDirection.reverse && _showFab) {
                setState(() => _showFab = false);
              } else if (n.direction == ScrollDirection.idle && !_showFab) {
                setState(() => _showFab = true);
              }
              return false;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _SearchBar(onFilterTap: _openFilter),
                const SizedBox(height: 12),
                BlocBuilder<CategoriesViewModel, CategoriesState>(
                  buildWhen: (prev, curr) =>
                      prev.categoriesState != curr.categoriesState,
                  builder: (context, state) {
                    if (state.categoriesState.isLoading) {
                      return const SizedBox(
                        height: 40,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final cats = state.categoriesState.data ?? [];
                    if (cats.isEmpty) return const SizedBox(height: 40);
                    return AppTabBarWidget(
                      key: ValueKey(cats.length),
                      tabs: <TabItem>[const _AllTab(), ...cats],
                      onTabChanged: (tab) {
                        if (tab is _AllTab) {
                          context.read<CategoriesViewModel>().doEvent(
                            const AllProductsSelectedEvent(),
                          );
                        } else {
                          context.read<CategoriesViewModel>().doEvent(
                            CategorySelectedEvent(tab.id),
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: AppRefreshIndicator(
                    onRefresh: _onRefresh,
                    child: BlocBuilder<CategoriesViewModel, CategoriesState>(
                      buildWhen: (prev, curr) =>
                          prev.productsState != curr.productsState,
                      builder: (context, state) {
                        final ps = state.productsState;
                        if (ps.data != null) {
                          final data = ps.data as ProductsResponseEntity;
                          return ProductsGridView(
                            products: data.products,
                            onAddToCart: (_) {},
                            currentPage: data.metadata?.currentPage ?? 1,
                            totalPages: data.metadata?.totalPages ?? 1,
                            isLoading: false,
                            onLoadMore: () => context
                                .read<CategoriesViewModel>()
                                .doEvent(const LoadMoreProductsEvent()),
                          );
                        }
                        return ProductsGridView(
                          products: const [],
                          onAddToCart: (_) {},
                          currentPage: 1,
                          totalPages: 1,
                          isLoading: ps.isLoading || ps.msg == null,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _showFab ? 1.0 : 0.0,
          child: FloatingActionButton.extended(
            onPressed: _openFilter,
            backgroundColor: AppColors.pink,
            icon: SvgPicture.asset(
              Assets.assetsIconsTune,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
            label: const Text(
              AppStrings.filter,
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _AllTab implements TabItem {
  const _AllTab();

  @override
  String get id => 'all';

  @override
  String get name => AppStrings.all;
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onFilterTap});

  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
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
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 48,
            height: 48,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onFilterTap,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.placeHolder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.assetsIconsSort,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.gray,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

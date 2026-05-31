import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/cubit/home_view_model.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/states/home_events.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/states/home_state.dart';
import 'package:flower_app/features/home_screen/presentation/widgets/best_seller_item.dart';
import 'package:flower_app/features/home_screen/presentation/widgets/category_item.dart';
import 'package:flower_app/features/home_screen/presentation/widgets/occasion_item.dart';
import 'package:flower_app/features/home_screen/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onCategoryViewAll, this.onCategoryTap});

  final VoidCallback? onCategoryViewAll;
  final void Function(String categoryId)? onCategoryTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeViewModel>();
    _cubit.doEvent(const LoadHomeDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.pink,
            onRefresh: () async {
              _cubit.doEvent(const RetryLoadHomeDataEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationWidget(),
                  const SizedBox(height: 24),
                  _buildCategoriesSection(state),
                  const SizedBox(height: 24),
                  _buildBestSellerSection(state),
                  const SizedBox(height: 24),
                  _buildOccasionsSection(state),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      title: Row(
        children: [
          CircleAvatar(
            radius: 12,
            child: Image.asset(Assets.assetsImagesAppIcon, height: 15),
          ),
          const SizedBox(width: 4),
          Text(AppStrings.appName, style: TextStyles.appNameTextStyle),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: AppStrings.search,
                constraints: const BoxConstraints(maxHeight: 40),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.placeHolder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: AppColors.pink),
                ),
                prefixIconConstraints: const BoxConstraints(maxHeight: 18),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SvgPicture.asset(
                    Assets.assetsIconsSearch,
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

  Widget _buildLocationWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.assetsIconsLocationOn,
            colorFilter: const ColorFilter.mode(
              AppColors.black,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Text(AppStrings.deliverTo, style: TextStyles.bodyRegular12),
          const SizedBox(width: 4),
          Text(
            AppStrings.defaultAddress,
            style: TextStyles.bodyRegular12.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.pink,
            size: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.categories,
          actionText: AppStrings.viewAll,
          onTap: () => widget.onCategoryViewAll?.call(),
        ),
        const SizedBox(height: 12),
        _buildCategoriesContent(state.categoriesState),
      ],
    );
  }

  Widget _buildCategoriesContent(BaseState<List<CategoryEntity>> state) {
    if (state.isLoading) return _buildHorizontalLoader();

    if (state.msg != null) {
      return _buildSectionError(
        message: state.msg!,
        onRetry: () => _cubit.doEvent(const RetryLoadHomeDataEvent()),
      );
    }

    final categories = state.data;
    if (categories == null || categories.isEmpty) {
      return _buildEmpty(AppStrings.noCategoriesFound);
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final category = categories[index];
          return CategoryItem(
            id: category.id ?? '',
            name: category.name ?? '',
            image: category.image ?? '',
            onTap: () => widget.onCategoryTap?.call(category.id ?? ''),
          );
        },
      ),
    );
  }

  Widget _buildBestSellerSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.bestSeller,
          actionText: AppStrings.viewAll,
          onTap: () => Navigator.pushNamed(context, AppRoutesName.bestSeller),
        ),
        const SizedBox(height: 12),
        _buildBestSellerContent(state.bestSellersState),
      ],
    );
  }

  Widget _buildBestSellerContent(BaseState<List<BestSellerEntity>> state) {
    if (state.isLoading) return _buildHorizontalLoader();

    if (state.msg != null) {
      return _buildSectionError(
        message: state.msg!,
        onRetry: () => _cubit.doEvent(const RetryLoadHomeDataEvent()),
      );
    }

    final bestSellers = state.data;
    if (bestSellers == null || bestSellers.isEmpty) {
      return _buildEmpty(AppStrings.noProductsFound);
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: bestSellers.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final product = bestSellers[index];
          return BestSellerItem(
            id: product.id ?? '',
            name: product.title ?? '',
            image: product.imgCover ?? '',
            price: product.priceAfterDiscount ?? product.price ?? 0,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutesName.productDetails,
              arguments: product.id,
            ),
          );
        },
      ),
    );
  }

  Widget _buildOccasionsSection(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.occasions,
          actionText: AppStrings.viewAll,
          onTap: () => Navigator.pushNamed(context, AppRoutesName.occasions),
        ),
        const SizedBox(height: 12),
        _buildOccasionsContent(state.occasionsState),
      ],
    );
  }

  Widget _buildOccasionsContent(BaseState<List<OccasionEntity>> state) {
    if (state.isLoading) return _buildHorizontalLoader();

    if (state.msg != null) {
      return _buildSectionError(
        message: state.msg!,
        onRetry: () => _cubit.doEvent(const RetryLoadHomeDataEvent()),
      );
    }

    final occasions = state.data;
    if (occasions == null || occasions.isEmpty) {
      return _buildEmpty(AppStrings.noOccasionsFound);
    }

    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: occasions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final occasion = occasions[index];
          return OccasionItem(
            id: occasion.id ?? '',
            name: occasion.name ?? '',
            image: occasion.image ?? '',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutesName.occasions,
              arguments: occasion.id,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalLoader() {
    return const SizedBox(
      height: 100,
      child: Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.pink),
      ),
    );
  }

  Widget _buildSectionError({
    required String message,
    required VoidCallback onRetry,
  }) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyles.bodyRegular12.copyWith(color: AppColors.red),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.retry,
                style: TextStyles.bodyRegular12.copyWith(color: AppColors.pink),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          message,
          style: TextStyles.bodyRegular12.copyWith(color: AppColors.gray),
        ),
      ),
    );
  }
}

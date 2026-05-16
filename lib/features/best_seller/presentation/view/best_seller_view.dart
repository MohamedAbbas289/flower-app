import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/reusable_widgets/products_grid_view.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_cubit.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_event.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BestSellerView extends StatelessWidget {
  const BestSellerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BestSellerCubit>(
      create: (context) =>
          getIt<BestSellerCubit>()..doEvent(FetchBestSellerProductsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.bestSellerTitle),
              Text(
                AppStrings.bestSellerSubTitle,
                style: TextStyles.bodyRegular13,
              ),
            ],
          ),
        ),
        body: BlocConsumer<BestSellerCubit, BestSellerState>(
          listenWhen: (previous, current) =>
              previous.bestSellerState.msg != current.bestSellerState.msg &&
              current.bestSellerState.msg != null,
          listener: (context, state) {
            AppSnackBar.showError(context, state.bestSellerState.msg!);
          },
          buildWhen: (previous, current) =>
              previous.bestSellerState != current.bestSellerState,
          builder: (context, state) {
            final bs = state.bestSellerState;

            if (bs.msg != null && bs.data == null) {
              return Center(child: Text(bs.msg!, textAlign: TextAlign.center));
            }

            return ProductsGridView(
              isLoading: bs.isLoading && (bs.data == null || bs.data!.isEmpty),
              products: bs.data ?? [],
              onAddToCart: (_) {},
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
        ),
      ),
    );
  }
}

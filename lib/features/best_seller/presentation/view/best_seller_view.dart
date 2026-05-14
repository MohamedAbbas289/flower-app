import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/reusable_widgets/products_grid_view.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_cubit.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_event.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BestSellerView extends StatelessWidget {
  const BestSellerView({super.key});
  // final bestSellerCubit=getIt
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BestSellerCubit>(
      create: (context) =>
          getIt<BestSellerCubit>()..doEvent(FetchBestSellerProductsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.bestSellerTitle),
          // add sub title as text
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 20),
            child: Text(
              AppStrings.bestSellerSubTitle,
              style: TextStyles.bodyRegular13,
            ),
          ),
        ),
        body: BlocConsumer<BestSellerCubit, BestSellerState>(
          listenWhen: (previous, current) =>
              previous.bestSellerState != current.bestSellerState,
          listener: (context, state) {
            if (state.bestSellerState.msg != '' ||
                state.bestSellerState.msg != null) {
              AppSnackBar.showError(context, state.bestSellerState.msg ?? '');
            }
          },

          buildWhen: (previous, current) =>
              previous.bestSellerState != current.bestSellerState,
          builder: (context, state) {
            if (state.bestSellerState.isLoading) {
              return ProductsGridView(
                isLoading: true,
                products: const [],
                onAddToCart: (productId) {},
                currentPage: 1,
                totalPages: 1,
              );
            } else if (state.bestSellerState.data != null) {
              return ProductsGridView(
                isLoading: false,
                products: state.bestSellerState.data ?? [],
                onAddToCart: (productId) {},
                currentPage: 1,
                totalPages: 1,
              );
            } else {
              return Center(
                child: Text(
                  AppStrings.noInternetConnection,
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

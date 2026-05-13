import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/best_seller_model.dart';
import '../../../domain/entities/category_model.dart';
import '../../../domain/entities/occasion_model.dart';
import '../../../domain/use_cases/get_best_seller_use_case.dart';
import '../../../domain/use_cases/get_category_use_cases.dart';
import '../../../domain/use_cases/get_occasion_use_case.dart';
import '../states/home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  HomeViewModel(
    this.getCategoriesUseCase,
    this.getOccasionUseCase,
    this.getBestSellerUseCase,
  ) : super(HomeState());
  final GetCategoryUseCases getCategoriesUseCase;
  final GetOccasionUseCase getOccasionUseCase;
  final GetBestSellerUseCase getBestSellerUseCase;


  Future<void> init() async {
     getCategories();
     getOccasion();
     getBestSeller();
  }

  Future<void> getCategories() async {
    emit(state.copyWith(categoriesLoading: true, categoriesError: ''));
    final result = await getCategoriesUseCase();
    switch (result) {
      case SuccessBaseResponse<List<CategoryModel>>():
        emit(
          state.copyWith(
            categoriesLoading: false,
            categories: result.data,
          ),
        );
        break;
      case ErrorBaseResponse<List<CategoryModel>>():
        emit(
          state.copyWith(
            categoriesLoading: false,
            categoriesError: result.errorMessage,
          ),
        );
        break;
    }
  }

  Future<void> getOccasion() async {
    emit(state.copyWith(occasionsLoading: true, occasionsError: ''));
    final result = await getOccasionUseCase();
    switch (result) {
      case SuccessBaseResponse<List<OccasionModel>>():
        emit(
          state.copyWith(
            occasionsLoading: false,
            occasions: result.data,
          ),
        );
        break;
      case ErrorBaseResponse<List<OccasionModel>>():
        emit(
          state.copyWith(
            occasionsLoading: false,
            occasionsError: result.errorMessage,
          ),
        );
        break;
    }
  }

  Future<void> getBestSeller() async {
    emit(state.copyWith(bestSellersLoading: true, bestSellersError: ''));
    final result = await getBestSellerUseCase();
    switch (result) {
      case SuccessBaseResponse<List<BestSellerModel>>():
        emit(
          state.copyWith(
            bestSellersLoading: false,
            bestSellers: result.data,
          ),
        );
        break;
      case ErrorBaseResponse<List<BestSellerModel>>():
        emit(
          state.copyWith(
            bestSellersLoading: false,
            bestSellersError: result.errorMessage,
          ),
        );
        break;
    }
  }
}

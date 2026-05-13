import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/best_seller_model.dart';
import '../../../domain/entities/category_model.dart';
import '../../../domain/entities/occasion_model.dart';
import '../../../domain/use_cases/get_best_seller_use_case.dart';
import '../../../domain/use_cases/get_category_use_cases.dart';
import '../../../domain/use_cases/get_occasion_use_case.dart';
import '../states/home_events.dart';
import '../states/home_state.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {

  final GetCategoryUseCases _getCategoriesUseCase;
  final GetOccasionUseCase _getOccasionUseCase;
  final GetBestSellerUseCase _getBestSellerUseCase;
  HomeViewModel(
    this._getCategoriesUseCase,
    this._getOccasionUseCase,
    this._getBestSellerUseCase,
  ) : super(HomeState());



  Future<void> doEvent(HomeEvents event) async {
    if (event is GetAllDataEvent) {
      await _getAllData();
    } else if (event is GetBestSellerEvent) {
      await _getBestSeller();
    } else if (event is GetCategoryEvent) {
      await _getCategories();
    } else if (event is GetOccasionEvent) {
      await _getOccasion();
    }
  }


  Future<void> _getAllData() async {
     _getCategories();
     _getOccasion();
     _getBestSeller();
  }

  Future<void> _getCategories() async {
    emit(state.copyWith(categoriesLoading: true, categoriesError: ''));
    final result = await _getCategoriesUseCase();
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

  Future<void> _getOccasion() async {
    emit(state.copyWith(occasionsLoading: true, occasionsError: ''));
    final result = await _getOccasionUseCase();
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

  Future<void> _getBestSeller() async {
    emit(state.copyWith(bestSellersLoading: true, bestSellersError: ''));
    final result = await _getBestSellerUseCase();
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

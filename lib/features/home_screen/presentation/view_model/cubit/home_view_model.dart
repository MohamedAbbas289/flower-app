import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_best_seller_use_case.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_category_use_cases.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_occasion_use_case.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/states/home_events.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/states/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetCategoryUseCases _getCategoryUseCases;
  final GetBestSellerUseCase _getBestSellerUseCase;
  final GetOccasionUseCase _getOccasionUseCase;

  HomeViewModel(
    this._getCategoryUseCases,
    this._getBestSellerUseCase,
    this._getOccasionUseCase,
  ) : super(const HomeState());

  void doEvent(HomeEvent event) {
    switch (event) {
      case LoadHomeDataEvent():
        _loadHomeData();
      case RetryLoadHomeDataEvent():
        _retryLoadHomeData();
    }
  }

  void _loadHomeData() {
    _fetchCategories();
    _fetchBestSellers();
    _fetchOccasions();
  }

  void _retryLoadHomeData() {
    if (state.categoriesState.msg != null) _fetchCategories();
    if (state.bestSellersState.msg != null) _fetchBestSellers();
    if (state.occasionsState.msg != null) _fetchOccasions();
  }

  Future<void> _fetchCategories() async {
    emit(state.copyWith(categoriesState: BaseState.loading()));
    final response = await _getCategoryUseCases();
    switch (response) {
      case SuccessBaseResponse():
        emit(state.copyWith(categoriesState: BaseState.success(response.data)));
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            categoriesState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _fetchBestSellers() async {
    emit(state.copyWith(bestSellersState: BaseState.loading()));
    final response = await _getBestSellerUseCase();
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(bestSellersState: BaseState.success(response.data)),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            bestSellersState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> _fetchOccasions() async {
    emit(state.copyWith(occasionsState: BaseState.loading()));
    final response = await _getOccasionUseCase();
    switch (response) {
      case SuccessBaseResponse():
        emit(state.copyWith(occasionsState: BaseState.success(response.data)));
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            occasionsState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

}

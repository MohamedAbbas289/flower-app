import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/occasions/domain/entities/products_entity.dart';
import 'package:flower_app/features/occasions/domain/usecases/get_occasions_use_case.dart';
import 'package:flower_app/features/occasions/domain/usecases/get_products_by_occasiousecase.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_events.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OccasionsViewModel extends Cubit<OccasionsState> {
  OccasionsViewModel(
    this._getOccasionsUseCase,
    this._getProductsByOccasionUseCase,
  ) : super(const OccasionsState());

  final GetOccasionsUseCase _getOccasionsUseCase;
  final GetProductsByOccasionUseCase _getProductsByOccasionUseCase;

  static const int _limit = 10;

  void doEvent(OccasionsEvent event) {
    switch (event) {
      case GetOccasionsEvent():
        _getOccasions();
        break;

      case GetProductsByOccasionEvent():
        _getProductsByOccasion(event.occasionId);
        break;

      case LoadMoreProductsEvent():
        _loadMoreProducts();
        break;

      case LoadMoreOccasionsEvent():
        _loadMoreOccasions();
        break;
    }
  }

  Future<void> _getOccasions() async {
    emit(state.copyWith(
      occasionsState: BaseState<List<OccasionEntity>>.loading(),
    ));

    final response = await _getOccasionsUseCase.execute(
      page: 1,
      limit: _limit,
    );

    switch (response) {
      case SuccessBaseResponse<OccasionsEntity>():
        final data = response.data;

        emit(state.copyWith(
          occasionsState:
              BaseState<List<OccasionEntity>>.success(data.occasions),
          occasionsCurrentPage: data.currentPage,
          occasionsTotalPages: data.totalPages,
        ));

        if (data.occasions.isNotEmpty) {
          doEvent(
            GetProductsByOccasionEvent(
              occasionId: data.occasions.first.id,
            ),
          );
        }
        break;

      case ErrorBaseResponse<OccasionsEntity>():
        emit(state.copyWith(
          occasionsState:
              BaseState<List<OccasionEntity>>.error(
                response.errorMessage,
              ),
        ));
        break;
    }
  }

  Future<void> _loadMoreOccasions() async {
    if (state.isLoadingMoreOccasions) return;

    final nextPage = state.occasionsCurrentPage + 1;
    if (nextPage > state.occasionsTotalPages) return;

    emit(state.copyWith(isLoadingMoreOccasions: true));

    final response = await _getOccasionsUseCase.execute(
      page: nextPage,
      limit: _limit,
    );

    switch (response) {
      case SuccessBaseResponse<OccasionsEntity>():
        final data = response.data;

        final current = state.occasionsState.data ?? [];
        final updated = [...current, ...data.occasions];

        emit(state.copyWith(
          isLoadingMoreOccasions: false,
          occasionsCurrentPage: data.currentPage,
          occasionsTotalPages: data.totalPages,
          occasionsState:
              BaseState<List<OccasionEntity>>.success(updated),
        ));
        break;

      case ErrorBaseResponse<OccasionsEntity>():
        emit(state.copyWith(isLoadingMoreOccasions: false));
        break;
    }
  }

  Future<void> _getProductsByOccasion(String occasionId) async {
    emit(state.copyWith(
      selectedOccasionId: occasionId,
      currentPage: 1,
      totalPages: 1,
      productsState: BaseState<List<ProductEntity>>.loading(),
      paginationResetKey: state.paginationResetKey + 1,
    ));

    final response = await _getProductsByOccasionUseCase.execute(
      occasionId: occasionId,
      page: 1,
      limit: _limit,
    );

    switch (response) {
      case SuccessBaseResponse<ProductsEntity>():
        emit(state.copyWith(
          currentPage: response.data.currentPage,
          totalPages: response.data.totalPages,
          productsState: BaseState<List<ProductEntity>>.success(
            response.data.products,
          ),
        ));
        break;

      case ErrorBaseResponse<ProductsEntity>():
        emit(state.copyWith(
          productsState:
              BaseState<List<ProductEntity>>.error(
                response.errorMessage,
              ),
        ));
        break;
    }
  }

  Future<void> _loadMoreProducts() async {
    if (state.isLoadingMore) return;
    if (state.selectedOccasionId == null) return;

    final nextPage = state.currentPage + 1;
    if (nextPage > state.totalPages) return;

    emit(state.copyWith(isLoadingMore: true));

    final response = await _getProductsByOccasionUseCase.execute(
      occasionId: state.selectedOccasionId!,
      page: nextPage,
      limit: _limit,
    );

    switch (response) {
      case SuccessBaseResponse<ProductsEntity>():
        final current = state.productsState.data ?? [];
        final updated = [...current, ...response.data.products];

        emit(state.copyWith(
          isLoadingMore: false,
          currentPage: response.data.currentPage,
          totalPages: response.data.totalPages,
          productsState:
              BaseState<List<ProductEntity>>.success(updated),
        ));
        break;

      case ErrorBaseResponse<ProductsEntity>():
        emit(state.copyWith(isLoadingMore: false));
        break;
    }
  }
}
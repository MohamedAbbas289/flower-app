import 'dart:async';

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/search/domain/use_cases/search_products_use_case.dart';
import 'package:flower_app/features/search/presentation/view_model/search_events.dart';
import 'package:flower_app/features/search/presentation/view_model/search_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class SearchViewModel extends Cubit<SearchState> {
  SearchViewModel(this._searchProductsUseCase) : super(const SearchState()) {
    _querySubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen(_onSearchSubmitted);
  }

  final SearchProductsUseCase _searchProductsUseCase;
  final _querySubject = BehaviorSubject<String>();

  void doEvent(SearchEvents event) {
    switch (event) {
      case SearchSubmittedEvent():
        _querySubject.close();
        _onSearchSubmitted(event.query);
        break;
      case SearchClearedEvent():
        _onSearchCleared();
        break;
    }
  }

  void onSearchSubmitted(String query) {
    doEvent(SearchSubmittedEvent(query));
  }

  void onQueryChanged(String query) {
    if (query.trim().isEmpty) {
      _onSearchCleared();
      return;
    }
    _querySubject.add(query);
  }

  void onClearSearch() {
    doEvent(SearchClearedEvent());
  }

  Future<void> _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) return;

    emit(
      state.copyWith(
        productsState: BaseState<List<ProductEntity>>.loading(),
        isInitial: false,
      ),
    );

    final response = await _searchProductsUseCase.execute(query: query.trim());

    switch (response) {
      case SuccessBaseResponse<ProductsResponseEntity>():
        final products = response.data.products;
        emit(state.copyWith(productsState: BaseState.success(products)));
        break;
      case ErrorBaseResponse<ProductsResponseEntity>():
        emit(
          state.copyWith(productsState: BaseState.error(response.errorMessage)),
        );
        break;
    }
  }

  void _onSearchCleared() {
    if (!_querySubject.isClosed) _querySubject.add('');
    emit(const SearchState());
  }

  @override
  Future<void> close() {
    _querySubject.close();
    return super.close();
  }
}

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/categories/api/request_models/get_products_by_category_request_model.dart';
import 'package:flower_app/features/categories/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flower_app/features/categories/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_events.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesViewModel extends Cubit<CategoriesState> {
  CategoriesViewModel(
    this._getCategoriesUseCase,
    this._getProductsByCategoryUseCase,) : super(const CategoriesState());

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  final List<CategoryEntity> _categories = [];
  final List<ProductEntity> _allProducts = [];

  int _productsPage = 1;
  int _productsTotalPages = 1;

  void doEvent(CategoriesEvents event) {
    switch (event) {
      case LoadInitialDataEvent():
        _loadInitialData();
        break;
      case CategorySelectedEvent():
        _fetchProducts(categoryId: event.categoryId);
        break;
      case AllProductsSelectedEvent():
        _fetchProducts(categoryId: null);
        break;
      case SortSelectedEvent():
        _onSortSelected(sortType: event.sortType);
        break;
      case LoadMoreProductsEvent():
        _fetchProducts(categoryId: state.selectedCategoryId, isLoadMore: true);
        break;
      case RefreshEvent():
        _fetchProducts(categoryId: state.selectedCategoryId);
        break;
    }
  }

  Future<void> _loadInitialData() async {
    await _fetchCategories();
    await _fetchProducts(categoryId: null);
  }

  Future<void> _fetchCategories() async {
    _categories.clear();
    emit(state.copyWith(categoriesState: BaseState.loading()));

    const maxRetries = 3;
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      final response = await _getCategoriesUseCase.execute(page: 1, limit: 50);
      switch (response) {
        case SuccessBaseResponse<CategoriesResponseEntity>():
          _categories.addAll(response.data.categories);
          emit(state.copyWith(
            categoriesState: BaseState.success(List.unmodifiable(_categories)),
          ));
          return;
        case ErrorBaseResponse<CategoriesResponseEntity>():
          if (attempt < maxRetries - 1) {
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
            continue;
          }
          emit(state.copyWith(
            categoriesState: BaseState.error(response.errorMessage),
          ));
          return;
      }
    }
  }

  Future<void> _fetchProducts({
    String? categoryId,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (_productsPage >= _productsTotalPages) return;
      _productsPage++;
      emit(state.copyWith(
        productsState: state.productsState.copyWith(isLoading: true),
      ));
    } else {
      _productsPage = 1;
      _productsTotalPages = 1;
      _allProducts.clear();
      emit(state.copyWith(
        productsState: BaseState<ProductsResponseEntity>.loading(),
        selectedCategoryId: categoryId,
      ));
    }

    final response = await _getProductsByCategoryUseCase.execute(
      requestModel: GetProductsByCategoryRequestModel(categoryId: categoryId),
      page: _productsPage,
      limit: 10,
    );

    switch (response) {
      case SuccessBaseResponse<ProductsResponseEntity>():
        _allProducts.addAll(response.data.products);
        _productsPage = response.data.metadata?.currentPage ?? 1;
        _productsTotalPages = response.data.metadata?.totalPages ?? 1;
        emit(state.copyWith(
          productsState: BaseState.success(
            ProductsResponseEntity(
              products: List.unmodifiable(_allProducts),
              metadata: response.data.metadata,
            ),
          ),
        ));
        break;
      case ErrorBaseResponse<ProductsResponseEntity>():
        emit(state.copyWith(
          productsState: BaseState.error(response.errorMessage),
        ));
        break;
    }
  }

  void _onSortSelected({required SortType sortType}) {
    // TODO: implement sort
  }
}

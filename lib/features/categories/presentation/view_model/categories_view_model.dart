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

  int _productsPage = 1;
  int _productsTotalPages = 1;
  int _paginationResetKey = 0;
  int _fetchVersion = 0;

  int get paginationResetKey => _paginationResetKey;

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

    final response = await _getCategoriesUseCase.execute(page: 1, limit: 50);
    switch (response) {
      case SuccessBaseResponse<CategoriesResponseEntity>():
        _categories.addAll(response.data.categories);
        emit(state.copyWith(
          categoriesState: BaseState.success(List.unmodifiable(_categories)),
        ));
        return;
      case ErrorBaseResponse<CategoriesResponseEntity>():
        emit(state.copyWith(
          categoriesState: BaseState.error(response.errorMessage),
        ));
        return;
    }
  }

  Future<void> _fetchProducts({
    String? categoryId,
    bool isLoadMore = false,
  }) async {
    if (isLoadMore) {
      if (_productsPage >= _productsTotalPages) return;
      _productsPage++;
    } else {
      _fetchVersion++;
      _productsPage = 1;
      _productsTotalPages = 1;
      _paginationResetKey++;
      emit(state.copyWith(
        productsState: BaseState<ProductsResponseEntity>.loading(),
        selectedCategoryId: categoryId,
        clearSelectedCategoryId: categoryId == null,
      ));
    }

    final myVersion = _fetchVersion;

    final response = await _getProductsByCategoryUseCase.execute(
      requestModel: GetProductsByCategoryRequestModel(categoryId: categoryId),
      page: _productsPage,
      limit: 10,
    );

    if (myVersion != _fetchVersion) return;

    switch (response) {
      case SuccessBaseResponse<ProductsResponseEntity>():
        _productsPage = response.data.metadata?.currentPage ?? 1;
        _productsTotalPages = response.data.metadata?.totalPages ?? 1;

        final previousProducts = isLoadMore
            ? (state.productsState.data?.products ?? <ProductEntity>[])
            : <ProductEntity>[];

        emit(state.copyWith(
          productsState: BaseState.success(
            ProductsResponseEntity(
              products: [
                ...previousProducts,
                ...response.data.products,
              ],
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

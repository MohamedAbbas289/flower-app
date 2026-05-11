import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/request_models/get_products_by_category_request_model.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flower_app/features/categories/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_events.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesViewModel extends Cubit<CategoriesBaseState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;

  List<ProductEntity> _allFetchedProducts = [];

  CategoriesViewModel(
    this._getCategoriesUseCase,
    this._getProductsByCategoryUseCase,
  ) : super(const CategoriesInitial());

  void doEvent(CategoriesEvents event) {
    switch (event) {
      case LoadInitialDataEvent():
        _loadInitialData();
        break;
      case CategorySelectedEvent():
        _onCategorySelected(categoryId: event.categoryId);
        break;
      case AllProductsSelectedEvent():
        _fetchProducts(categoryId: null);
        break;
      case SortSelectedEvent():
        _onSortSelected(sortType: event.sortType);
        break;
    }
  }

  Future<void> _loadInitialData() async {
    await _fetchCategories();
    await _fetchProducts(categoryId: null);
  }

  Future<void> _fetchCategories() async {
    emit(const CategoriesLoading());
    final response = await _getCategoriesUseCase.execute();
    switch (response) {
      case SuccessBaseResponse<List<CategoryEntity>>():
        emit(CategoriesSuccess(response.data));
        break;
      case ErrorBaseResponse<List<CategoryEntity>>():
        emit(CategoriesError(response.errorMessage));
        break;
    }
  }

  Future<void> _fetchProducts({String? categoryId}) async {
    emit(const ProductsLoading());
    final response = await _getProductsByCategoryUseCase.execute(
      requestModel: GetProductsByCategoryRequestModel(categoryId: categoryId),
    );
    switch (response) {
      case SuccessBaseResponse<List<ProductEntity>>():
        _allFetchedProducts = response.data;
        emit(
          ProductsSuccess(
            products: _allFetchedProducts,
            selectedCategoryId: categoryId,
          ),
        );
        break;
      case ErrorBaseResponse<List<ProductEntity>>():
        emit(ProductsError(response.errorMessage));
        break;
    }
  }

  void _onCategorySelected({required String categoryId}) {
    _fetchProducts(categoryId: categoryId);
  }

  void _onSortSelected({required SortType sortType}) {
    final sorted = List<ProductEntity>.from(_allFetchedProducts);
    switch (sortType) {
      case SortType.lowestPrice:
        sorted.sort(
          (a, b) => (a.priceAfterDiscount ?? a.price ?? 0).compareTo(
            b.priceAfterDiscount ?? b.price ?? 0,
          ),
        );
        break;
      case SortType.highestPrice:
        sorted.sort(
          (a, b) => (b.priceAfterDiscount ?? b.price ?? 0).compareTo(
            a.priceAfterDiscount ?? a.price ?? 0,
          ),
        );
        break;
      case SortType.newest:
        break;
      case SortType.oldest:
        sorted.sort((a, b) {
          return b.id?.compareTo(a.id ?? '') ?? 0;
        });
        break;
      case SortType.discount:
        sorted.sort((a, b) => (b.discount ?? 0).compareTo(a.discount ?? 0));
        break;
    }

    final currentSelectedCategoryId = state is ProductsSuccess
        ? (state as ProductsSuccess).selectedCategoryId
        : null;

    emit(
      ProductsSuccess(
        products: sorted,
        selectedCategoryId: currentSelectedCategoryId,
      ),
    );
  }
}

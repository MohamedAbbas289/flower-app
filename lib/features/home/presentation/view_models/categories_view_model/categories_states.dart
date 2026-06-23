import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/home/domain/entities/category_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/home/presentation/view_models/categories_view_model/categories_events.dart';

class CategoriesState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<ProductsResponseEntity> productsState;
  final String? selectedCategoryId;
  final SortType? selectedSortType;

  const CategoriesState({
    this.categoriesState = const BaseState(),
    this.productsState = const BaseState(),
    this.selectedCategoryId,
    this.selectedSortType,
  });

  CategoriesState copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<ProductsResponseEntity>? productsState,
    String? selectedCategoryId,
    bool clearSelectedCategoryId = false,
    SortType? selectedSortType,
    bool clearSelectedSortType = false,
  }) {
    return CategoriesState(
      categoriesState: categoriesState ?? this.categoriesState,
      productsState: productsState ?? this.productsState,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      selectedSortType: clearSelectedSortType
          ? null
          : (selectedSortType ?? this.selectedSortType),
    );
  }

  @override
  List<Object?> get props =>
      [categoriesState, productsState, selectedCategoryId, selectedSortType];
}

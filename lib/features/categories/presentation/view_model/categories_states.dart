import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';

class CategoriesState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<ProductsResponseEntity> productsState;
  final String? selectedCategoryId;

  const CategoriesState({
    this.categoriesState = const BaseState(),
    this.productsState = const BaseState(),
    this.selectedCategoryId,
  });

  CategoriesState copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<ProductsResponseEntity>? productsState,
    String? selectedCategoryId,
    bool clearSelectedCategoryId = false,
  }) {
    return CategoriesState(
      categoriesState: categoriesState ?? this.categoriesState,
      productsState: productsState ?? this.productsState,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
    );
  }

  @override
  List<Object?> get props =>
      [categoriesState, productsState, selectedCategoryId];
}

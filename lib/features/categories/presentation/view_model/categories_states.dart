import 'package:equatable/equatable.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';

abstract class CategoriesBaseState extends Equatable {
  const CategoriesBaseState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesBaseState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesBaseState {
  const CategoriesLoading();
}

class CategoriesSuccess extends CategoriesBaseState {
  final List<CategoryEntity> categories;

  const CategoriesSuccess(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoriesError extends CategoriesBaseState {
  final String error;

  const CategoriesError(this.error);

  @override
  List<Object?> get props => [error];
}

class ProductsLoading extends CategoriesBaseState {
  const ProductsLoading();
}

class ProductsSuccess extends CategoriesBaseState {
  final List<ProductEntity> products;
  final String? selectedCategoryId;

  const ProductsSuccess({required this.products, this.selectedCategoryId});

  @override
  List<Object?> get props => [products, selectedCategoryId];
}

class ProductsError extends CategoriesBaseState {
  final String error;

  const ProductsError(this.error);

  @override
  List<Object?> get props => [error];
}

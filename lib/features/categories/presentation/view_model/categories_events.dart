import 'package:equatable/equatable.dart';

enum SortType { lowestPrice, highestPrice, newest, oldest, discount }

sealed class CategoriesEvents extends Equatable {
  const CategoriesEvents();

  @override
  List<Object?> get props => [];
}

class LoadInitialDataEvent extends CategoriesEvents {
  const LoadInitialDataEvent();
}

class CategorySelectedEvent extends CategoriesEvents {
  final String categoryId;

  const CategorySelectedEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class AllProductsSelectedEvent extends CategoriesEvents {
  const AllProductsSelectedEvent();
}

class SortSelectedEvent extends CategoriesEvents {
  final SortType sortType;

  const SortSelectedEvent(this.sortType);

  @override
  List<Object?> get props => [sortType];
}

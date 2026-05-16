enum SortType { lowestPrice, highestPrice, newest, oldest, discount }

sealed class CategoriesEvents {}

class LoadInitialDataEvent extends CategoriesEvents {
  final String? initialCategoryId;
  LoadInitialDataEvent({this.initialCategoryId});
}

class CategorySelectedEvent extends CategoriesEvents {
  final String categoryId;

  CategorySelectedEvent(this.categoryId);
}

class AllProductsSelectedEvent extends CategoriesEvents {}

class SortSelectedEvent extends CategoriesEvents {
  final SortType sortType;

  SortSelectedEvent(this.sortType);
}

class LoadMoreProductsEvent extends CategoriesEvents {}

class RefreshEvent extends CategoriesEvents {}

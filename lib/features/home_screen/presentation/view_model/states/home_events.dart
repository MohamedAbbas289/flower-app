abstract class HomeEvent {
  const HomeEvent();
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class RetryLoadHomeDataEvent extends HomeEvent {
  const RetryLoadHomeDataEvent();
}

class NavigateToCategoryEvent extends HomeEvent {
  final String categoryId;
  const NavigateToCategoryEvent({required this.categoryId});
}

class NavigateToOccasionEvent extends HomeEvent {
  final String occasionId;
  const NavigateToOccasionEvent({required this.occasionId});
}

class NavigateToBestSellerEvent extends HomeEvent {
  final String productId;
  const NavigateToBestSellerEvent({required this.productId});
}

class NavigateToViewAllCategoriesEvent extends HomeEvent {
  const NavigateToViewAllCategoriesEvent();
}

class NavigateToViewAllOccasionsEvent extends HomeEvent {
  const NavigateToViewAllOccasionsEvent();
}

class NavigateToViewAllBestSellersEvent extends HomeEvent {
  const NavigateToViewAllBestSellersEvent();
}

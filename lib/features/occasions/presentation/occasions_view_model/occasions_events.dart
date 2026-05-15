sealed class OccasionsEvent {}

class GetOccasionsEvent extends OccasionsEvent {}

class GetProductsByOccasionEvent extends OccasionsEvent {
  final String occasionId;
  GetProductsByOccasionEvent({required this.occasionId});
}

class LoadMoreProductsEvent extends OccasionsEvent {}

class LoadMoreOccasionsEvent extends OccasionsEvent {}
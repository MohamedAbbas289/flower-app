import 'package:equatable/equatable.dart';

sealed class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();
  @override
  List<Object?> get props => [];
}

class GetProductDetailsEvent extends ProductDetailsEvent {
  // final String productId;

  const GetProductDetailsEvent(
    // {required this.productId}
  );

  @override
  List<Object?> get props => [
    // productId
  ];
}

// TODO: add productID when feature best seller is implemented

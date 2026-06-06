import 'package:equatable/equatable.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final String productId;
  final int quantity;

  const AddToCartEvent({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateLocalQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;
  const UpdateLocalQuantityEvent({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class UpdateQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantityEvent({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveProductfromCart extends CartEvent {
  final String productId;

  const RemoveProductfromCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

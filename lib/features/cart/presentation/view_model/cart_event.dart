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

class UpdateQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantityEvent({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveCartItemEvent extends CartEvent {
  final String itemId;

  const RemoveCartItemEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
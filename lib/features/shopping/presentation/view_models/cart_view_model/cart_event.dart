import 'package:equatable/equatable.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final CartRequestModel requestModel;

  const AddToCartEvent({required this.requestModel});

  @override
  List<Object?> get props => [requestModel];
}

class UpdateLocalQuantityEvent extends CartEvent {
  final CartRequestModel requestModel;

  const UpdateLocalQuantityEvent({required this.requestModel});

  @override
  List<Object?> get props => [requestModel];
}

class UpdateQuantityEvent extends CartEvent {
  final CartRequestModel requestModel;

  const UpdateQuantityEvent({required this.requestModel});

  @override
  List<Object?> get props => [requestModel];
}

class RemoveProductfromCartEvent extends CartEvent {
  final String productId;

  const RemoveProductfromCartEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

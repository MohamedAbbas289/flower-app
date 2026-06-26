import 'dart:async';

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/clear_cart_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/get_cart_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/update_quantity_use_case.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_event.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CartViewModel extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateQuantityUseCase _updateQuantityUseCase;
  final RemoveProductFromCartUseCase _removeProductFromCartUseCase;
  final ClearCartUseCase _clearCartUseCase;

  final Map<String, Timer> _debounceTimers = {};

  CartViewModel(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateQuantityUseCase,
    this._removeProductFromCartUseCase,
    this._clearCartUseCase,
  ) : super(const CartState());

  @override
  Future<void> close() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    return super.close();
  }

  void doEvent(CartEvent event) {
    switch (event) {
      case LoadCartEvent():
        _loadCart();
      case AddToCartEvent():
        _addToCart(event.requestModel);
      case UpdateLocalQuantityEvent():
        _updateLocalQuantity(event.requestModel);
      case UpdateQuantityEvent():
        _debounceUpdateQuantity(event.requestModel);
      case RemoveProductfromCartEvent():
        _removeProduct(event.productId);
      case ClearCartEvent():
        _clearCart();
    }
  }

  Future<void> _loadCart() async {
    if (isClosed) return;
    emit(state.copyWith(cartState: BaseState.loading()));
    final response = await _getCartUseCase.execute();
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(cartState: BaseState.success(response.data)));
      case ErrorBaseResponse<CartEntity>():
        emit(state.copyWith(cartState: BaseState.error(response.errorMessage)));
    }
  }

  Future<void> _addToCart(CartRequestModel requestModel) async {
    if (isClosed) return;
    emit(state.copyWith(addToCartState: BaseState.loading()));
    final response = await _addToCartUseCase.execute(request: requestModel);
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(
          addToCartState: BaseState.success(response.data),
          cartState: BaseState.success(response.data),
        ));
      case ErrorBaseResponse<CartEntity>():
        emit(state.copyWith(
          addToCartState: BaseState.error(response.errorMessage),
        ));
    }
  }

  void _updateLocalQuantity(CartRequestModel requestModel) {
    if (isClosed) return;
    final updated = Map<String, int>.from(state.localQuantities);
    updated[requestModel.productId] = requestModel.quantity;
    emit(state.copyWith(localQuantities: updated));
  }

  void _debounceUpdateQuantity(CartRequestModel requestModel) {
    _debounceTimers[requestModel.productId]?.cancel();
    _debounceTimers[requestModel.productId] = Timer(
      const Duration(milliseconds: 500),
      () => _updateQuantity(requestModel),
    );
  }

  Future<void> _updateQuantity(CartRequestModel requestModel) async {
    if (isClosed) return;
    final response = await _updateQuantityUseCase.execute(request: requestModel);
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(
          updateQuantityState: BaseState.success(response.data),
          cartState: BaseState.success(response.data),
          localQuantities: {},
        ));
      case ErrorBaseResponse<CartEntity>():
        emit(state.copyWith(
          updateQuantityState: BaseState.error(response.errorMessage),
          localQuantities: {},
        ));
    }
  }

  Future<void> _removeProduct(String productId) async {
    if (isClosed) return;
    emit(state.copyWith(removeItemState: BaseState.loading()));
    final response = await _removeProductFromCartUseCase.execute(
      productId: productId,
    );
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(
          removeItemState: BaseState.success(response.data),
          cartState: BaseState.success(response.data),
        ));
      case ErrorBaseResponse<CartEntity>():
        emit(state.copyWith(
          removeItemState: BaseState.error(response.errorMessage),
        ));
    }
  }

  Future<void> _clearCart() async {
    if (isClosed) return;
    emit(state.copyWith(clearCartState: BaseState.loading()));
    final response = await _clearCartUseCase.execute();
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(
          clearCartState: BaseState.success(response.data),
          cartState: BaseState.success(response.data),
        ));
      case ErrorBaseResponse<CartEntity>():
        emit(state.copyWith(
          clearCartState: BaseState.error(response.errorMessage),
        ));
    }
  }
}

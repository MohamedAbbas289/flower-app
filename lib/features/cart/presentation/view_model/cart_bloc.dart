import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flower_app/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flower_app/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:flower_app/features/cart/domain/use_cases/update_quantity_use_case.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateQuantityUseCase _updateQuantityUseCase;
  final RemoveProductFromCartUseCase _removeProductFromCartUseCase;

  CartBloc(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateQuantityUseCase,
    this._removeProductFromCartUseCase,
  ) : super(const CartState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateLocalQuantityEvent>((event, emit) {
      final updated = Map<String, int>.from(state.localQuantities);
      updated[event.productId] = event.quantity;
      emit(state.copyWith(localQuantities: updated));
    });

    on<UpdateQuantityEvent>(
      _onUpdateQuantity,
      transformer: (events, mapper) => events
          .groupBy((e) => e.productId)
          .flatMap(
            (group) => group
                .debounceTime(const Duration(milliseconds: 500))
                .switchMap(mapper),
          ),
    );
    on<RemoveProductfromCart>(_onRemoveProductfromCart);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(cartState: BaseState.loading()));
    final response = await _getCartUseCase();
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(state.copyWith(cartState: BaseState.success(response.data)));
      case ErrorBaseResponse<CartEntity>():
        emit(state.copyWith(cartState: BaseState.error(response.errorMessage)));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(addToCartState: BaseState.loading()));
    final response = await _addToCartUseCase(event.productId, event.quantity);
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            addToCartState: BaseState.success(response.data),
            cartState: BaseState.success(response.data),
          ),
        );
      case ErrorBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            addToCartState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

 Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final response = await _updateQuantityUseCase(
      event.productId,
      event.quantity,
    );
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            updateQuantityState: BaseState.success(response.data),
            cartState: BaseState.success(response.data),
            localQuantities: {},
          ),
        );
      case ErrorBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            updateQuantityState: BaseState.error(response.errorMessage),
            localQuantities: {},
          ),
        );
    }
  }
  Future<void> _onRemoveProductfromCart(
    RemoveProductfromCart event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(removeItemState: BaseState.loading()));
    final response = await _removeProductFromCartUseCase(event.productId);
    switch (response) {
      case SuccessBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            removeItemState: BaseState.success(response.data),
            cartState: BaseState.success(response.data),
          ),
        );
      case ErrorBaseResponse<CartEntity>():
        emit(
          state.copyWith(
            removeItemState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }
}

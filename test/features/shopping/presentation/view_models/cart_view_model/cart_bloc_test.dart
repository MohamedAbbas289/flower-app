import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/clear_cart_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/get_cart_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/update_quantity_use_case.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_view_model.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_event.dart';
import 'package:flower_app/features/shopping/presentation/view_models/cart_view_model/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_bloc_test.mocks.dart';

@GenerateMocks([
  GetCartUseCase,
  AddToCartUseCase,
  UpdateQuantityUseCase,
  RemoveProductFromCartUseCase,
  ClearCartUseCase,
])
void main() {
  late MockGetCartUseCase mockGetCartUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockUpdateQuantityUseCase mockUpdateQuantityUseCase;
  late MockRemoveProductFromCartUseCase mockRemoveProductFromCartUseCase;
  late MockClearCartUseCase mockClearCartUseCase;

  const tRequestModel = CartRequestModel(productId: 'product_123', quantity: 2);

  const tErrorMessage = 'somethingWentWrong';

  const tCartEntity = CartEntity(
    id: 'cart_1',
    cartItems: [],
    totalPrice: 100,
    totalPriceAfterDiscount: 90,
    discount: 10,
    numOfCartItems: 0,
  );

  const tEmptyCartEntity = CartEntity(
    id: '',
    cartItems: [],
    totalPrice: 0,
    totalPriceAfterDiscount: 0,
    discount: 0,
    numOfCartItems: 0,
  );

  CartViewModel buildBloc() => CartViewModel(
    mockGetCartUseCase,
    mockAddToCartUseCase,
    mockUpdateQuantityUseCase,
    mockRemoveProductFromCartUseCase,
    mockClearCartUseCase,
  );

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockUpdateQuantityUseCase = MockUpdateQuantityUseCase();
    mockRemoveProductFromCartUseCase = MockRemoveProductFromCartUseCase();
    mockClearCartUseCase = MockClearCartUseCase();
    provideDummy<BaseResponse<CartEntity>>(
      SuccessBaseResponse(data: tCartEntity),
    );
  });

  group('LoadCartEvent', () {
    blocTest<CartViewModel, CartState>(
      'emits loading then success when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockGetCartUseCase.execute(),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));
      },
      act: (bloc) => bloc.doEvent(const LoadCartEvent()),
      expect: () => [
        CartState(cartState: BaseState.loading()),
        CartState(cartState: BaseState.success(tCartEntity)),
      ],
    );

    blocTest<CartViewModel, CartState>(
      'emits loading then error when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockGetCartUseCase.execute()).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) => bloc.doEvent(const LoadCartEvent()),
      expect: () => [
        CartState(cartState: BaseState.loading()),
        CartState(cartState: BaseState.error(tErrorMessage)),
      ],
    );
  });

  group('AddToCartEvent', () {
    blocTest<CartViewModel, CartState>(
      'emits loading then success when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockAddToCartUseCase.execute(request: tRequestModel),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));
      },
      act: (bloc) =>
          bloc.doEvent(AddToCartEvent(requestModel: tRequestModel)),
      expect: () => [
        CartState(addToCartState: BaseState.loading()),
        CartState(
          addToCartState: BaseState.success(tCartEntity),
          cartState: BaseState.success(tCartEntity),
        ),
      ],
    );

    blocTest<CartViewModel, CartState>(
      'emits loading then error when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockAddToCartUseCase.execute(request: tRequestModel)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) =>
          bloc.doEvent(AddToCartEvent(requestModel: tRequestModel)),
      expect: () => [
        CartState(addToCartState: BaseState.loading()),
        CartState(addToCartState: BaseState.error(tErrorMessage)),
      ],
    );
  });

  group('UpdateLocalQuantityEvent', () {
    blocTest<CartViewModel, CartState>(
      'emits state with updated localQuantities',
      build: buildBloc,
      act: (bloc) => bloc.doEvent(
        UpdateLocalQuantityEvent(requestModel: tRequestModel),
      ),
      expect: () => [
        CartState(localQuantities: {tRequestModel.productId: tRequestModel.quantity}),
      ],
    );
  });

  group('UpdateQuantityEvent', () {
    blocTest<CartViewModel, CartState>(
      'emits success and clears localQuantities when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockUpdateQuantityUseCase.execute(request: tRequestModel),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));
      },
      act: (bloc) => bloc.doEvent(
        UpdateQuantityEvent(requestModel: tRequestModel),
      ),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        CartState(
          updateQuantityState: BaseState.success(tCartEntity),
          cartState: BaseState.success(tCartEntity),
          localQuantities: {},
        ),
      ],
    );

    blocTest<CartViewModel, CartState>(
      'emits error and clears localQuantities when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockUpdateQuantityUseCase.execute(request: tRequestModel)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) => bloc.doEvent(
        UpdateQuantityEvent(requestModel: tRequestModel),
      ),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        CartState(
          updateQuantityState: BaseState.error(tErrorMessage),
          localQuantities: {},
        ),
      ],
    );
  });

  group('RemoveProductfromCart', () {
    blocTest<CartViewModel, CartState>(
      'emits loading then success when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockRemoveProductFromCartUseCase.execute(productId: tRequestModel.productId),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));
      },
      act: (bloc) => bloc.doEvent(RemoveProductfromCartEvent(productId: tRequestModel.productId)),
      expect: () => [
        CartState(removeItemState: BaseState.loading()),
        CartState(
          removeItemState: BaseState.success(tCartEntity),
          cartState: BaseState.success(tCartEntity),
        ),
      ],
    );

    blocTest<CartViewModel, CartState>(
      'emits loading then error when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockRemoveProductFromCartUseCase.execute(productId: tRequestModel.productId)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) => bloc.doEvent(RemoveProductfromCartEvent(productId: tRequestModel.productId)),
      expect: () => [
        CartState(removeItemState: BaseState.loading()),
        CartState(removeItemState: BaseState.error(tErrorMessage)),
      ],
    );
  });

  group('ClearCartEvent', () {
    blocTest<CartViewModel, CartState>(
      'emits loading then success when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockClearCartUseCase.execute(),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEmptyCartEntity));
      },
      act: (bloc) => bloc.doEvent(const ClearCartEvent()),
      expect: () => [
        CartState(clearCartState: BaseState.loading()),
        CartState(
          clearCartState: BaseState.success(tEmptyCartEntity),
          cartState: BaseState.success(tEmptyCartEntity),
        ),
      ],
    );

    blocTest<CartViewModel, CartState>(
      'emits loading then error when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockClearCartUseCase.execute()).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) => bloc.doEvent(const ClearCartEvent()),
      expect: () => [
        CartState(clearCartState: BaseState.loading()),
        CartState(clearCartState: BaseState.error(tErrorMessage)),
      ],
    );
  });
}

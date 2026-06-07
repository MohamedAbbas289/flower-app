import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/use_cases/add_to_cart_use_case.dart';
import 'package:flower_app/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flower_app/features/cart/domain/use_cases/remove_product_from_cart_use_case.dart';
import 'package:flower_app/features/cart/domain/use_cases/update_quantity_use_case.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_event.dart';
import 'package:flower_app/features/cart/presentation/view_model/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_bloc_test.mocks.dart';

@GenerateMocks([
  GetCartUseCase,
  AddToCartUseCase,
  UpdateQuantityUseCase,
  RemoveProductFromCartUseCase,
])
void main() {
  late MockGetCartUseCase mockGetCartUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockUpdateQuantityUseCase mockUpdateQuantityUseCase;
  late MockRemoveProductFromCartUseCase mockRemoveProductFromCartUseCase;

  const tProductId = 'product_123';
  const tQuantity = 2;
  const tErrorMessage = 'somethingWentWrong';

  const tCartEntity = CartEntity(
    id: 'cart_1',
    cartItems: [],
    totalPrice: 100,
    totalPriceAfterDiscount: 90,
    discount: 10,
    numOfCartItems: 0,
  );

  CartBloc buildBloc() => CartBloc(
    mockGetCartUseCase,
    mockAddToCartUseCase,
    mockUpdateQuantityUseCase,
    mockRemoveProductFromCartUseCase,
  );

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockUpdateQuantityUseCase = MockUpdateQuantityUseCase();
    mockRemoveProductFromCartUseCase = MockRemoveProductFromCartUseCase();
    provideDummy<BaseResponse<CartEntity>>(
      SuccessBaseResponse(data: tCartEntity),
    );
  });

  group('LoadCartEvent', () {
    blocTest<CartBloc, CartState>(
      'emits loading then success when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockGetCartUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));
      },
      act: (bloc) => bloc.add(LoadCartEvent()),
      expect: () => [
        CartState(cartState: BaseState.loading()),
        CartState(cartState: BaseState.success(tCartEntity)),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits loading then error when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockGetCartUseCase()).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) => bloc.add(LoadCartEvent()),
      expect: () => [
        CartState(cartState: BaseState.loading()),
        CartState(cartState: BaseState.error(tErrorMessage)),
      ],
    );
  });

  group('AddToCartEvent', () {
    blocTest<CartBloc, CartState>(
      'emits loading then success when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockAddToCartUseCase(tProductId, tQuantity),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));
      },
      act: (bloc) =>
          bloc.add(AddToCartEvent(productId: tProductId, quantity: tQuantity)),
      expect: () => [
        CartState(addToCartState: BaseState.loading()),
        CartState(
          addToCartState: BaseState.success(tCartEntity),
          cartState: BaseState.success(tCartEntity),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits loading then error when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockAddToCartUseCase(tProductId, tQuantity)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) =>
          bloc.add(AddToCartEvent(productId: tProductId, quantity: tQuantity)),
      expect: () => [
        CartState(addToCartState: BaseState.loading()),
        CartState(addToCartState: BaseState.error(tErrorMessage)),
      ],
    );
  });

  group('UpdateLocalQuantityEvent', () {
    blocTest<CartBloc, CartState>(
      'emits state with updated localQuantities',
      build: buildBloc,
      act: (bloc) => bloc.add(
        UpdateLocalQuantityEvent(productId: tProductId, quantity: tQuantity),
      ),
      expect: () => [
        CartState(localQuantities: {tProductId: tQuantity}),
      ],
    );
  });

  group('UpdateQuantityEvent', () {
    blocTest<CartBloc, CartState>(
      'emits success and clears localQuantities when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockUpdateQuantityUseCase(tProductId, tQuantity),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));
      },
      act: (bloc) => bloc.add(
        UpdateQuantityEvent(productId: tProductId, quantity: tQuantity),
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

    blocTest<CartBloc, CartState>(
      'emits error and clears localQuantities when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockUpdateQuantityUseCase(tProductId, tQuantity)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) => bloc.add(
        UpdateQuantityEvent(productId: tProductId, quantity: tQuantity),
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
    blocTest<CartBloc, CartState>(
      'emits loading then success when use case returns success',
      build: buildBloc,
      setUp: () {
        when(
          mockRemoveProductFromCartUseCase(tProductId),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));
      },
      act: (bloc) => bloc.add(RemoveProductfromCart(productId: tProductId)),
      expect: () => [
        CartState(removeItemState: BaseState.loading()),
        CartState(
          removeItemState: BaseState.success(tCartEntity),
          cartState: BaseState.success(tCartEntity),
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits loading then error when use case returns error',
      build: buildBloc,
      setUp: () {
        when(mockRemoveProductFromCartUseCase(tProductId)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception(tErrorMessage)),
        );
      },
      act: (bloc) => bloc.add(RemoveProductfromCart(productId: tProductId)),
      expect: () => [
        CartState(removeItemState: BaseState.loading()),
        CartState(removeItemState: BaseState.error(tErrorMessage)),
      ],
    );
  });
}

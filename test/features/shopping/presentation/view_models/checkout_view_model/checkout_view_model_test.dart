import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/config/firebase/last_address_firestore_service.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/checkout/domain/entities/payment_method.dart';
import 'package:flower_app/features/checkout/presentation/view_model/cubit/checkout_view_model.dart';
import 'package:flower_app/features/checkout/presentation/view_model/states/checkout_events.dart';
import 'package:flower_app/features/checkout/presentation/view_model/states/checkout_states.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/payment/domain/use_cases/create_cash_order_use_case.dart';
import 'package:flower_app/features/payment/domain/use_cases/get_checkout_session_use_case.dart';
import 'package:flower_app/features/saved_address/domain/use_cases/saved_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'checkout_view_model_test.mocks.dart';

@GenerateMocks([
  GetAddressesUseCase,
  LastAddressFirestoreService,
  CreateCashOrderUseCase,
  GetCheckoutSessionUseCase,
])
void main() {
  late MockGetAddressesUseCase getAddressesUseCase;
  late MockLastAddressFirestoreService lastAddressFirestoreService;
  late MockCreateCashOrderUseCase createCashOrderUseCase;
  late MockGetCheckoutSessionUseCase getCheckoutSessionUseCase;

  const tAddress1 = AddressEntity(
    id: '1',
    street: 'Street 1',
    phone: '0100000001',
    city: 'Cairo',
    lat: '30.0',
    long: '31.0',
  );
  const tAddress2 = AddressEntity(
    id: '2',
    street: 'Street 2',
    phone: '0100000002',
    city: 'Giza',
    lat: '30.1',
    long: '31.1',
  );

  const tCashOrderEntity = CashOrderEntity(
    id: 'order_1',
    orderNumber: '1001',
    totalPrice: 100,
    state: 'pending',
  );

  const tCheckoutSessionEntity = CheckoutSessionEntity(
    sessionId: 'sess_1',
    sessionUrl: 'https://checkout.stripe.com/session',
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse(data: const []),
    );
    provideDummy<BaseResponse<CashOrderEntity>>(
      SuccessBaseResponse(data: tCashOrderEntity),
    );
    provideDummy<BaseResponse<CheckoutSessionEntity>>(
      SuccessBaseResponse(data: tCheckoutSessionEntity),
    );
  });

  setUp(() {
    getAddressesUseCase = MockGetAddressesUseCase();
    lastAddressFirestoreService = MockLastAddressFirestoreService();
    createCashOrderUseCase = MockCreateCashOrderUseCase();
    getCheckoutSessionUseCase = MockGetCheckoutSessionUseCase();
    when(
      lastAddressFirestoreService.saveLastAddress(any),
    ).thenAnswer((_) async {});
  });

  CheckoutViewModel buildCubit() => CheckoutViewModel(
    getAddressesUseCase,
    lastAddressFirestoreService,
    createCashOrderUseCase,
    getCheckoutSessionUseCase,
  );

  group('LoadCheckoutDataEvent', () {
    blocTest<CheckoutViewModel, CheckoutStates>(
      'selects the address matching the cached last address',
      build: buildCubit,
      setUp: () {
        when(getAddressesUseCase()).thenAnswer(
          (_) async =>
              SuccessBaseResponse(data: const [tAddress1, tAddress2]),
        );
        when(
          lastAddressFirestoreService.getLastAddress(),
        ).thenAnswer((_) async => tAddress1);
      },
      act: (cubit) => cubit.doEvent(const LoadCheckoutDataEvent()),
      expect: () => [
        const CheckoutStates(addressesState: BaseState(isLoading: true)),
        CheckoutStates(
          addressesState: BaseState<List<AddressEntity>>.success(const [
            tAddress1,
            tAddress2,
          ]),
          selectedAddress: tAddress1,
        ),
      ],
    );

    blocTest<CheckoutViewModel, CheckoutStates>(
      'falls back to the last address when firestore has nothing cached',
      build: buildCubit,
      setUp: () {
        when(getAddressesUseCase()).thenAnswer(
          (_) async =>
              SuccessBaseResponse(data: const [tAddress1, tAddress2]),
        );
        when(
          lastAddressFirestoreService.getLastAddress(),
        ).thenAnswer((_) async => null);
      },
      act: (cubit) => cubit.doEvent(const LoadCheckoutDataEvent()),
      expect: () => [
        const CheckoutStates(addressesState: BaseState(isLoading: true)),
        CheckoutStates(
          addressesState: BaseState<List<AddressEntity>>.success(const [
            tAddress1,
            tAddress2,
          ]),
          selectedAddress: tAddress2,
        ),
      ],
    );

    blocTest<CheckoutViewModel, CheckoutStates>(
      'falls back to the last address when the cached address is not in the list',
      build: buildCubit,
      setUp: () {
        when(getAddressesUseCase()).thenAnswer(
          (_) async =>
              SuccessBaseResponse(data: const [tAddress1, tAddress2]),
        );
        when(lastAddressFirestoreService.getLastAddress()).thenAnswer(
          (_) async => const AddressEntity(id: 'missing'),
        );
      },
      act: (cubit) => cubit.doEvent(const LoadCheckoutDataEvent()),
      expect: () => [
        const CheckoutStates(addressesState: BaseState(isLoading: true)),
        CheckoutStates(
          addressesState: BaseState<List<AddressEntity>>.success(const [
            tAddress1,
            tAddress2,
          ]),
          selectedAddress: tAddress2,
        ),
      ],
    );

    blocTest<CheckoutViewModel, CheckoutStates>(
      'leaves selectedAddress null and skips the firestore lookup when there are no saved addresses',
      build: buildCubit,
      setUp: () {
        when(
          getAddressesUseCase(),
        ).thenAnswer((_) async => SuccessBaseResponse(data: const []));
      },
      act: (cubit) => cubit.doEvent(const LoadCheckoutDataEvent()),
      expect: () => [
        const CheckoutStates(addressesState: BaseState(isLoading: true)),
        CheckoutStates(
          addressesState: BaseState<List<AddressEntity>>.success(const []),
        ),
      ],
      verify: (_) {
        verifyNever(lastAddressFirestoreService.getLastAddress());
      },
    );

    blocTest<CheckoutViewModel, CheckoutStates>(
      'emits an error state when the use case fails',
      build: buildCubit,
      setUp: () {
        when(getAddressesUseCase()).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('boom')),
        );
      },
      act: (cubit) => cubit.doEvent(const LoadCheckoutDataEvent()),
      expect: () => [
        const CheckoutStates(addressesState: BaseState(isLoading: true)),
        isA<CheckoutStates>().having(
          (s) => s.addressesState.msg,
          'msg',
          isNotNull,
        ),
      ],
    );
  });

  group('SelectAddressEvent', () {
    blocTest<CheckoutViewModel, CheckoutStates>(
      'updates the selected address',
      build: buildCubit,
      act: (cubit) => cubit.doEvent(const SelectAddressEvent(tAddress2)),
      expect: () => [const CheckoutStates(selectedAddress: tAddress2)],
    );
  });

  group('SelectPaymentMethodEvent', () {
    blocTest<CheckoutViewModel, CheckoutStates>(
      'updates the selected payment method',
      build: buildCubit,
      act: (cubit) =>
          cubit.doEvent(const SelectPaymentMethodEvent(PaymentMethod.card)),
      expect: () => [
        const CheckoutStates(paymentMethod: PaymentMethod.card),
      ],
    );
  });

  group('ToggleGiftEvent', () {
    blocTest<CheckoutViewModel, CheckoutStates>(
      'updates the isGift flag',
      build: buildCubit,
      act: (cubit) => cubit.doEvent(const ToggleGiftEvent(true)),
      expect: () => [const CheckoutStates(isGift: true)],
    );
  });

  group('PlaceOrderEvent', () {
    blocTest<CheckoutViewModel, CheckoutStates>(
      'does nothing when no address is selected',
      build: buildCubit,
      act: (cubit) => cubit.doEvent(const PlaceOrderEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(createCashOrderUseCase(any));
        verifyNever(getCheckoutSessionUseCase(any));
      },
    );

    blocTest<CheckoutViewModel, CheckoutStates>(
      'emits CashOrderPlaced and saves the address on cash success',
      build: buildCubit,
      seed: () => const CheckoutStates(selectedAddress: tAddress1),
      setUp: () {
        when(createCashOrderUseCase(any)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCashOrderEntity),
        );
      },
      act: (cubit) => cubit.doEvent(const PlaceOrderEvent()),
      expect: () => [
        const CheckoutStates(
          selectedAddress: tAddress1,
          placeOrderState: BaseState(isLoading: true),
        ),
        CheckoutStates(
          selectedAddress: tAddress1,
          placeOrderState: BaseState<PlaceOrderResult>.success(
            CashOrderPlaced(tCashOrderEntity.orderNumber ?? ''),
          ),
        ),
      ],
      verify: (_) {
        verify(
          createCashOrderUseCase(PaymentRequestModel.fromAddress(tAddress1)),
        ).called(1);
        verify(lastAddressFirestoreService.saveLastAddress(tAddress1)).called(1);
      },
    );

    blocTest<CheckoutViewModel, CheckoutStates>(
      'emits an error state when the cash order fails',
      build: buildCubit,
      seed: () => const CheckoutStates(selectedAddress: tAddress1),
      setUp: () {
        when(createCashOrderUseCase(any)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('boom')),
        );
      },
      act: (cubit) => cubit.doEvent(const PlaceOrderEvent()),
      expect: () => [
        const CheckoutStates(
          selectedAddress: tAddress1,
          placeOrderState: BaseState(isLoading: true),
        ),
        isA<CheckoutStates>().having(
          (s) => s.placeOrderState.msg,
          'msg',
          isNotNull,
        ),
      ],
      verify: (_) {
        verifyNever(lastAddressFirestoreService.saveLastAddress(any));
      },
    );

    blocTest<CheckoutViewModel, CheckoutStates>(
      'emits StripeSessionCreated on card success',
      build: buildCubit,
      seed: () => const CheckoutStates(
        selectedAddress: tAddress1,
        paymentMethod: PaymentMethod.card,
      ),
      setUp: () {
        when(getCheckoutSessionUseCase(any)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCheckoutSessionEntity),
        );
      },
      act: (cubit) => cubit.doEvent(const PlaceOrderEvent()),
      expect: () => [
        const CheckoutStates(
          selectedAddress: tAddress1,
          paymentMethod: PaymentMethod.card,
          placeOrderState: BaseState(isLoading: true),
        ),
        CheckoutStates(
          selectedAddress: tAddress1,
          paymentMethod: PaymentMethod.card,
          placeOrderState: BaseState<PlaceOrderResult>.success(
            StripeSessionCreated(tCheckoutSessionEntity.sessionUrl ?? ''),
          ),
        ),
      ],
      verify: (_) {
        verify(
          getCheckoutSessionUseCase(
            PaymentRequestModel.fromAddress(tAddress1),
          ),
        ).called(1);
        verifyNever(lastAddressFirestoreService.saveLastAddress(any));
      },
    );

    blocTest<CheckoutViewModel, CheckoutStates>(
      'emits an error state when creating the checkout session fails',
      build: buildCubit,
      seed: () => const CheckoutStates(
        selectedAddress: tAddress1,
        paymentMethod: PaymentMethod.card,
      ),
      setUp: () {
        when(getCheckoutSessionUseCase(any)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('boom')),
        );
      },
      act: (cubit) => cubit.doEvent(const PlaceOrderEvent()),
      expect: () => [
        const CheckoutStates(
          selectedAddress: tAddress1,
          paymentMethod: PaymentMethod.card,
          placeOrderState: BaseState(isLoading: true),
        ),
        isA<CheckoutStates>().having(
          (s) => s.placeOrderState.msg,
          'msg',
          isNotNull,
        ),
      ],
    );
  });
}

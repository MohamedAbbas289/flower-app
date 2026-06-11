import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/payment/domain/use_cases/create_cash_order_use_case.dart';
import 'package:flower_app/features/payment/domain/use_cases/get_checkout_session_use_case.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_cubit.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'payment_cubit_test.mocks.dart';

@GenerateMocks([CreateCashOrderUseCase, GetCheckoutSessionUseCase])
void main() {
  late PaymentCubit cubit;
  late MockCreateCashOrderUseCase mockCreateCashOrderUseCase;
  late MockGetCheckoutSessionUseCase mockGetCheckoutSessionUseCase;

  final tRequestModel = PaymentRequestModel(
    shippingAddress: ShippingAddressRequestModel(
      street: 'Test Street',
      phone: '01234567890',
      city: 'Cairo',
      lat: '31.2',
      long: '29.9',
    ),
  );

  final tCashOrderEntity = CashOrderEntity(
    id: 'order_123',
    userId: 'user_123',
    totalPrice: 550.0,
    message: 'success',
  );

  final tCheckoutSessionEntity = CheckoutSessionEntity(
    status: 'open',
    sessionUrl: 'https://checkout.stripe.com/pay/cs_test_123',
  );

  setUpAll(() {
    provideDummy<BaseResponse<CashOrderEntity>>(
      SuccessBaseResponse<CashOrderEntity>(data: tCashOrderEntity),
    );
    provideDummy<BaseResponse<CashOrderEntity>>(
      ErrorBaseResponse<CashOrderEntity>(exception: Exception('dummy')),
    );
    provideDummy<BaseResponse<CheckoutSessionEntity>>(
      SuccessBaseResponse<CheckoutSessionEntity>(data: tCheckoutSessionEntity),
    );
    provideDummy<BaseResponse<CheckoutSessionEntity>>(
      ErrorBaseResponse<CheckoutSessionEntity>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockCreateCashOrderUseCase = MockCreateCashOrderUseCase();
    mockGetCheckoutSessionUseCase = MockGetCheckoutSessionUseCase();
    cubit = PaymentCubit(
      mockCreateCashOrderUseCase,
      mockGetCheckoutSessionUseCase,
    );
  });

  tearDown(() => cubit.close());

  // =========================
  // CREATE CASH ORDER
  // =========================
  group('createCashOrder', () {
    blocTest<PaymentCubit, PaymentState>(
      'emits loading then success on success',
      setUp: () {
        when(
          mockCreateCashOrderUseCase(requestModel: anyNamed('requestModel')),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tCashOrderEntity));
      },
      build: () => cubit,
      act: (c) => c.createCashOrder(requestModel: tRequestModel),
      expect: () => [
        isA<PaymentState>().having(
          (s) => s.cashOrderState.isLoading,
          'isLoading',
          true,
        ),
        isA<PaymentState>()
            .having((s) => s.cashOrderState.isLoading, 'isLoading', false)
            .having((s) => s.cashOrderState.data, 'data', tCashOrderEntity),
      ],
    );

    blocTest<PaymentCubit, PaymentState>(
      'emits loading then error on failure',
      setUp: () {
        when(
          mockCreateCashOrderUseCase(requestModel: anyNamed('requestModel')),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
      },
      build: () => cubit,
      act: (c) => c.createCashOrder(requestModel: tRequestModel),
      expect: () => [
        isA<PaymentState>().having(
          (s) => s.cashOrderState.isLoading,
          'isLoading',
          true,
        ),
        isA<PaymentState>()
            .having((s) => s.cashOrderState.isLoading, 'isLoading', false)
            .having((s) => s.cashOrderState.data, 'data', null)
            .having((s) => s.cashOrderState.msg, 'msg', isNotNull),
      ],
    );
  });

  // =========================
  // CREATE CHECKOUT SESSION
  // =========================
  group('createCheckoutSession', () {
    blocTest<PaymentCubit, PaymentState>(
      'emits loading then success on success',
      setUp: () {
        when(
          mockGetCheckoutSessionUseCase(requestModel: anyNamed('requestModel')),
        ).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCheckoutSessionEntity),
        );
      },
      build: () => cubit,
      act: (c) => c.createCheckoutSession(requestModel: tRequestModel),
      expect: () => [
        isA<PaymentState>().having(
          (s) => s.checkoutSessionState.isLoading,
          'isLoading',
          true,
        ),
        isA<PaymentState>()
            .having((s) => s.checkoutSessionState.isLoading, 'isLoading', false)
            .having(
              (s) => s.checkoutSessionState.data,
              'data',
              tCheckoutSessionEntity,
            ),
      ],
    );

    blocTest<PaymentCubit, PaymentState>(
      'emits loading then error on failure',
      setUp: () {
        when(
          mockGetCheckoutSessionUseCase(requestModel: anyNamed('requestModel')),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
      },
      build: () => cubit,
      act: (c) => c.createCheckoutSession(requestModel: tRequestModel),
      expect: () => [
        isA<PaymentState>().having(
          (s) => s.checkoutSessionState.isLoading,
          'isLoading',
          true,
        ),
        isA<PaymentState>()
            .having((s) => s.checkoutSessionState.isLoading, 'isLoading', false)
            .having((s) => s.checkoutSessionState.data, 'data', null)
            .having((s) => s.checkoutSessionState.msg, 'msg', isNotNull),
      ],
    );
  });
}

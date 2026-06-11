import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/data/data_source_contract/payment_remote_data_source_contract.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/payment/data/repo_impl/payment_repo_impl.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'payment_repo_impl_test.mocks.dart';

@GenerateMocks([PaymentRemoteDataSourceContract])
void main() {
  late PaymentRepoImpl repo;
  late MockPaymentRemoteDataSourceContract mockDataSource;

  final tRequestModel = PaymentRequestModel(
    shippingAddress: ShippingAddressRequestModel(
      street: 'Test Street',
      phone: '01234567890',
      city: 'Cairo',
      lat: '31.2',
      long: '29.9',
    ),
  );

  final tCashOrderResponse = CashOrderResponseModel(
    message: 'success',
    order: CashOrderDataModel(
      id: 'order_123',
      user: 'user_123',
      totalOrderPrice: 550.0,
    ),
  );

  final tCheckoutSessionResponse = CheckoutSessionResponseModel(
    status: 'open',
    sessionUrl: 'https://checkout.stripe.com/pay/cs_test_123',
  );

  setUpAll(() {
    provideDummy<BaseResponse<CashOrderResponseModel>>(
      SuccessBaseResponse<CashOrderResponseModel>(data: tCashOrderResponse),
    );
    provideDummy<BaseResponse<CashOrderResponseModel>>(
      ErrorBaseResponse<CashOrderResponseModel>(exception: Exception('dummy')),
    );
    provideDummy<BaseResponse<CheckoutSessionResponseModel>>(
      SuccessBaseResponse<CheckoutSessionResponseModel>(
        data: tCheckoutSessionResponse,
      ),
    );
    provideDummy<BaseResponse<CheckoutSessionResponseModel>>(
      ErrorBaseResponse<CheckoutSessionResponseModel>(
        exception: Exception('dummy'),
      ),
    );
  });

  setUp(() {
    mockDataSource = MockPaymentRemoteDataSourceContract();
    repo = PaymentRepoImpl(mockDataSource);
  });

  // =========================
  // CREATE CASH ORDER
  // =========================
  group('createCashOrder', () {
    test('returns SuccessBaseResponse with mapped entity on success', () async {
      when(
        mockDataSource.createCashOrder(requestModel: anyNamed('requestModel')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tCashOrderResponse));

      final result = await repo.createCashOrder(requestModel: tRequestModel);

      expect(result, isA<SuccessBaseResponse<CashOrderEntity>>());
      final success = result as SuccessBaseResponse<CashOrderEntity>;
      expect(success.data.id, 'order_123');
      expect(success.data.totalPrice, 550.0);
    });

    test('returns ErrorBaseResponse on failure', () async {
      when(
        mockDataSource.createCashOrder(requestModel: anyNamed('requestModel')),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('error')),
      );

      final result = await repo.createCashOrder(requestModel: tRequestModel);

      expect(result, isA<ErrorBaseResponse<CashOrderEntity>>());
      final error = result as ErrorBaseResponse<CashOrderEntity>;
      expect(error.errorMessage, isNotEmpty);
    });
  });

  // =========================
  // CREATE CHECKOUT SESSION
  // =========================
  group('createCheckoutSession', () {
    test('returns SuccessBaseResponse with mapped entity on success', () async {
      when(
        mockDataSource.createCheckoutSession(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer(
        (_) async => SuccessBaseResponse(data: tCheckoutSessionResponse),
      );

      final result = await repo.createCheckoutSession(
        requestModel: tRequestModel,
      );

      expect(result, isA<SuccessBaseResponse<CheckoutSessionEntity>>());
      final success = result as SuccessBaseResponse<CheckoutSessionEntity>;
      expect(
        success.data.sessionUrl,
        'https://checkout.stripe.com/pay/cs_test_123',
      );
    });

    test('returns ErrorBaseResponse on failure', () async {
      when(
        mockDataSource.createCheckoutSession(
          requestModel: anyNamed('requestModel'),
        ),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('error')),
      );

      final result = await repo.createCheckoutSession(
        requestModel: tRequestModel,
      );

      expect(result, isA<ErrorBaseResponse<CheckoutSessionEntity>>());
      final error = result as ErrorBaseResponse<CheckoutSessionEntity>;
      expect(error.errorMessage, isNotEmpty);
    });
  });
}

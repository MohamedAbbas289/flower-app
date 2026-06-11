import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/api_client/payment_api_client.dart';
import 'package:flower_app/features/payment/api/data_source_impl/payment_remote_data_source_impl.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'payment_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([PaymentApiClient])
void main() {
  late PaymentRemoteDataSourceImpl dataSource;
  late MockPaymentApiClient mockApiClient;

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

  setUp(() {
    mockApiClient = MockPaymentApiClient();
    dataSource = PaymentRemoteDataSourceImpl(mockApiClient);
  });

  group('createCashOrder', () {
    test('returns SuccessBaseResponse on success', () async {
      when(
        mockApiClient.createCashOrder(any),
      ).thenAnswer((_) async => tCashOrderResponse);

      final result = await dataSource.createCashOrder(
        requestModel: tRequestModel,
      );

      expect(result, isA<SuccessBaseResponse<CashOrderResponseModel>>());
      final success = result as SuccessBaseResponse<CashOrderResponseModel>;
      expect(success.data.order?.id, 'order_123');
    });

    test('returns ErrorBaseResponse on exception', () async {
      when(
        mockApiClient.createCashOrder(any),
      ).thenThrow(Exception('network error'));

      final result = await dataSource.createCashOrder(
        requestModel: tRequestModel,
      );

      expect(result, isA<ErrorBaseResponse<CashOrderResponseModel>>());
      final error = result as ErrorBaseResponse<CashOrderResponseModel>;
      expect(error.errorMessage, isNotEmpty);
    });
  });

  group('createCheckoutSession', () {
    test('returns SuccessBaseResponse on success', () async {
      when(
        mockApiClient.createCheckoutSession(any),
      ).thenAnswer((_) async => tCheckoutSessionResponse);

      final result = await dataSource.createCheckoutSession(
        requestModel: tRequestModel,
      );

      expect(result, isA<SuccessBaseResponse<CheckoutSessionResponseModel>>());
      final success =
          result as SuccessBaseResponse<CheckoutSessionResponseModel>;
      expect(
        success.data.sessionUrl,
        'https://checkout.stripe.com/pay/cs_test_123',
      );
    });

    test('returns ErrorBaseResponse on exception', () async {
      when(
        mockApiClient.createCheckoutSession(any),
      ).thenThrow(Exception('network error'));

      final result = await dataSource.createCheckoutSession(
        requestModel: tRequestModel,
      );

      expect(result, isA<ErrorBaseResponse<CheckoutSessionResponseModel>>());
      final error = result as ErrorBaseResponse<CheckoutSessionResponseModel>;
      expect(error.errorMessage, isNotEmpty);
    });
  });
}

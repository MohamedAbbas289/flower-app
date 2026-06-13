import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/payment/api/api_client/payment_api_client.dart';
import 'package:flower_app/features/payment/api/data_source_impl/payment_remote_data_source_impl.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'payment_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([PaymentApiClient])
void main() {
  late MockPaymentApiClient mockApiClient;
  late PaymentRemoteDataSourceImpl dataSource;

  const tRequestModel = PaymentRequestModel(
    street: 'Street 1',
    phone: '0102419753',
    city: 'Cairo',
    lat: '30.0',
    long: '31.0',
  );

  const tCashOrderResponseModel = CashOrderResponseModel(
    orderId: 'order_1',
    orderNumber: '1001',
    totalPrice: 100,
    state: 'pending',
  );

  const tCheckoutSessionResponseModel = CheckoutSessionResponseModel(
    sessionId: 'sess_1',
    sessionUrl: 'https://checkout.stripe.com/session',
  );

  setUp(() {
    mockApiClient = MockPaymentApiClient();
    dataSource = PaymentRemoteDataSourceImpl(mockApiClient);
  });

  group('createCashOrder', () {
    test(
      'returns SuccessBaseResponse with CashOrderResponseModel on success',
      () async {
        when(
          mockApiClient.createCashOrder(tRequestModel.toJson()),
        ).thenAnswer((_) async => tCashOrderResponseModel);

        final result = await dataSource.createCashOrder(tRequestModel);

        expect(result, isA<SuccessBaseResponse<CashOrderResponseModel>>());
        expect((result as SuccessBaseResponse).data, tCashOrderResponseModel);
        verify(
          mockApiClient.createCashOrder(tRequestModel.toJson()),
        ).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Network error');
      when(
        mockApiClient.createCashOrder(tRequestModel.toJson()),
      ).thenThrow(tException);

      final result = await dataSource.createCashOrder(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CashOrderResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockApiClient.createCashOrder(tRequestModel.toJson())).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });

  group('createCheckoutSession', () {
    test(
      'returns SuccessBaseResponse with CheckoutSessionResponseModel on success',
      () async {
        when(
          mockApiClient.createCheckoutSession(
            tRequestModel.toJson(),
            Endpoints.stripeRedirectUrl,
          ),
        ).thenAnswer((_) async => tCheckoutSessionResponseModel);

        final result = await dataSource.createCheckoutSession(tRequestModel);

        expect(
          result,
          isA<SuccessBaseResponse<CheckoutSessionResponseModel>>(),
        );
        expect(
          (result as SuccessBaseResponse).data,
          tCheckoutSessionResponseModel,
        );
        verify(
          mockApiClient.createCheckoutSession(
            tRequestModel.toJson(),
            Endpoints.stripeRedirectUrl,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Network error');
      when(
        mockApiClient.createCheckoutSession(
          tRequestModel.toJson(),
          Endpoints.stripeRedirectUrl,
        ),
      ).thenThrow(tException);

      final result = await dataSource.createCheckoutSession(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CheckoutSessionResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(
        mockApiClient.createCheckoutSession(
          tRequestModel.toJson(),
          Endpoints.stripeRedirectUrl,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}

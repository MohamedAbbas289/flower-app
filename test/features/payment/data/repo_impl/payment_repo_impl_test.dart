import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/data/data_source_contract/payment_remote_data_source_contract.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/payment/data/repo_impl/payment_repo_impl.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'payment_repo_impl_test.mocks.dart';

@GenerateMocks([PaymentRemoteDataSourceContract])
void main() {
  late MockPaymentRemoteDataSourceContract mockDataSource;
  late PaymentRepoImpl repo;

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

  const tCashOrderEntity = CashOrderEntity(
    id: 'order_1',
    orderNumber: '1001',
    totalPrice: 100,
    state: 'pending',
  );

  const tCheckoutSessionResponseModel = CheckoutSessionResponseModel(
    sessionId: 'sess_1',
    sessionUrl: 'https://checkout.stripe.com/session',
  );

  const tCheckoutSessionEntity = CheckoutSessionEntity(
    sessionId: 'sess_1',
    sessionUrl: 'https://checkout.stripe.com/session',
  );

  final tException = Exception('Something went wrong');

  setUpAll(() {
    provideDummy<BaseResponse<CashOrderResponseModel>>(
      SuccessBaseResponse(data: tCashOrderResponseModel),
    );
    provideDummy<BaseResponse<CheckoutSessionResponseModel>>(
      SuccessBaseResponse(data: tCheckoutSessionResponseModel),
    );
  });

  setUp(() {
    mockDataSource = MockPaymentRemoteDataSourceContract();
    repo = PaymentRepoImpl(mockDataSource);
  });

  group('createCashOrder', () {
    test('returns SuccessBaseResponse with CashOrderEntity on success', () async {
      when(mockDataSource.createCashOrder(tRequestModel)).thenAnswer(
        (_) async => SuccessBaseResponse(data: tCashOrderResponseModel),
      );

      final result = await repo.createCashOrder(tRequestModel);

      expect(result, isA<SuccessBaseResponse<CashOrderEntity>>());
      expect((result as SuccessBaseResponse).data, tCashOrderEntity);
      verify(mockDataSource.createCashOrder(tRequestModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('returns ErrorBaseResponse when data source returns an error', () async {
      when(mockDataSource.createCashOrder(tRequestModel)).thenAnswer(
        (_) async => ErrorBaseResponse(exception: tException),
      );

      final result = await repo.createCashOrder(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CashOrderEntity>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockDataSource.createCashOrder(tRequestModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('createCheckoutSession', () {
    test('returns SuccessBaseResponse with CheckoutSessionEntity on success', () async {
      when(mockDataSource.createCheckoutSession(tRequestModel)).thenAnswer(
        (_) async => SuccessBaseResponse(data: tCheckoutSessionResponseModel),
      );

      final result = await repo.createCheckoutSession(tRequestModel);

      expect(result, isA<SuccessBaseResponse<CheckoutSessionEntity>>());
      expect((result as SuccessBaseResponse).data, tCheckoutSessionEntity);
      verify(mockDataSource.createCheckoutSession(tRequestModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });

    test('returns ErrorBaseResponse when data source returns an error', () async {
      when(mockDataSource.createCheckoutSession(tRequestModel)).thenAnswer(
        (_) async => ErrorBaseResponse(exception: tException),
      );

      final result = await repo.createCheckoutSession(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CheckoutSessionEntity>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockDataSource.createCheckoutSession(tRequestModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}

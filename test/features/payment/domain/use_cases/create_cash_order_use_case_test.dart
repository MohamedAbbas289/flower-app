import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/repo_contract/payment_repo_contract.dart';
import 'package:flower_app/features/payment/domain/use_cases/create_cash_order_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_cash_order_use_case_test.mocks.dart';

@GenerateMocks([PaymentRepoContract])
void main() {
  late MockPaymentRepoContract mockRepo;
  late CreateCashOrderUseCase useCase;

  const tRequestModel = PaymentRequestModel(
    street: 'Street 1',
    phone: '0102419753',
    city: 'Cairo',
    lat: '30.0',
    long: '31.0',
  );

  const tCashOrderEntity = CashOrderEntity(
    id: 'order_1',
    orderNumber: '1001',
    totalPrice: 100,
    state: 'pending',
  );

  setUpAll(() {
    provideDummy<BaseResponse<CashOrderEntity>>(
      SuccessBaseResponse(data: tCashOrderEntity),
    );
  });

  setUp(() {
    mockRepo = MockPaymentRepoContract();
    useCase = CreateCashOrderUseCase(mockRepo);
  });

  test('returns SuccessBaseResponse with CashOrderEntity on success', () async {
    when(mockRepo.createCashOrder(tRequestModel)).thenAnswer(
      (_) async => SuccessBaseResponse(data: tCashOrderEntity),
    );

    final result = await useCase(tRequestModel);

    expect(result, isA<SuccessBaseResponse<CashOrderEntity>>());
    expect((result as SuccessBaseResponse).data, tCashOrderEntity);
    verify(mockRepo.createCashOrder(tRequestModel)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('returns ErrorBaseResponse when repo returns an error', () async {
    final tException = Exception('Create cash order failed');
    when(mockRepo.createCashOrder(tRequestModel)).thenAnswer(
      (_) async => ErrorBaseResponse(exception: tException),
    );

    final result = await useCase(tRequestModel);

    expect(result, isA<ErrorBaseResponse<CashOrderEntity>>());
    expect((result as ErrorBaseResponse).exception, tException);
    verify(mockRepo.createCashOrder(tRequestModel)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}

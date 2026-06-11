import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/repo_contract/payment_repo_contract.dart';
import 'package:flower_app/features/payment/domain/use_cases/create_cash_order_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'create_cash_order_use_case_test.mocks.dart';

@GenerateMocks([PaymentRepoContract])
void main() {
  late CreateCashOrderUseCase useCase;
  late MockPaymentRepoContract mockRepo;

  final tRequestModel = PaymentRequestModel(
    shippingAddress: ShippingAddressRequestModel(
      street: 'Test Street',
      phone: '01234567890',
      city: 'Cairo',
      lat: '31.2',
      long: '29.9',
    ),
  );

  final tEntity = CashOrderEntity(
    id: 'order_123',
    userId: 'user_123',
    totalPrice: 550.0,
    message: 'success',
  );

  setUpAll(() {
    provideDummy<BaseResponse<CashOrderEntity>>(
      SuccessBaseResponse<CashOrderEntity>(data: tEntity),
    );
    provideDummy<BaseResponse<CashOrderEntity>>(
      ErrorBaseResponse<CashOrderEntity>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockRepo = MockPaymentRepoContract();
    useCase = CreateCashOrderUseCase(mockRepo);
  });

  group('call', () {
    test('delegates to repo and returns SuccessBaseResponse', () async {
      when(
        mockRepo.createCashOrder(requestModel: anyNamed('requestModel')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      final result = await useCase(requestModel: tRequestModel);

      expect(result, isA<SuccessBaseResponse<CashOrderEntity>>());
      expect((result as SuccessBaseResponse<CashOrderEntity>).data, tEntity);
      verify(mockRepo.createCashOrder(requestModel: tRequestModel)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns ErrorBaseResponse when repo returns error', () async {
      when(
        mockRepo.createCashOrder(requestModel: anyNamed('requestModel')),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('error')),
      );

      final result = await useCase(requestModel: tRequestModel);

      expect(result, isA<ErrorBaseResponse<CashOrderEntity>>());
      expect(
        (result as ErrorBaseResponse<CashOrderEntity>).errorMessage,
        isNotEmpty,
      );
      verify(mockRepo.createCashOrder(requestModel: tRequestModel)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}

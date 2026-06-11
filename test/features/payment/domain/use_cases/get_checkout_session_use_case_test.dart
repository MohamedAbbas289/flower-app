import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/payment/domain/repo_contract/payment_repo_contract.dart';
import 'package:flower_app/features/payment/domain/use_cases/get_checkout_session_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_checkout_session_use_case_test.mocks.dart';

@GenerateMocks([PaymentRepoContract])
void main() {
  late GetCheckoutSessionUseCase useCase;
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

  final tEntity = CheckoutSessionEntity(
    status: 'open',
    sessionUrl: 'https://checkout.stripe.com/pay/cs_test_123',
  );

  setUpAll(() {
    provideDummy<BaseResponse<CheckoutSessionEntity>>(
      SuccessBaseResponse<CheckoutSessionEntity>(data: tEntity),
    );
    provideDummy<BaseResponse<CheckoutSessionEntity>>(
      ErrorBaseResponse<CheckoutSessionEntity>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockRepo = MockPaymentRepoContract();
    useCase = GetCheckoutSessionUseCase(mockRepo);
  });

  group('call', () {
    test('delegates to repo and returns SuccessBaseResponse', () async {
      when(
        mockRepo.createCheckoutSession(requestModel: anyNamed('requestModel')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      final result = await useCase(requestModel: tRequestModel);

      expect(result, isA<SuccessBaseResponse<CheckoutSessionEntity>>());
      expect(
        (result as SuccessBaseResponse<CheckoutSessionEntity>).data,
        tEntity,
      );
      verify(
        mockRepo.createCheckoutSession(requestModel: tRequestModel),
      ).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns ErrorBaseResponse when repo returns error', () async {
      when(
        mockRepo.createCheckoutSession(requestModel: anyNamed('requestModel')),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('error')),
      );

      final result = await useCase(requestModel: tRequestModel);

      expect(result, isA<ErrorBaseResponse<CheckoutSessionEntity>>());
      expect(
        (result as ErrorBaseResponse<CheckoutSessionEntity>).errorMessage,
        isNotEmpty,
      );
      verify(
        mockRepo.createCheckoutSession(requestModel: tRequestModel),
      ).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}

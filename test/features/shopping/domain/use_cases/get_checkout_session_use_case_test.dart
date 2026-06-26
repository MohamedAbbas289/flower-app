import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:flower_app/features/shopping/domain/use_cases/get_checkout_session_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_checkout_session_use_case_test.mocks.dart';

@GenerateMocks([ShoppingRepositoryContract])
void main() {
  late MockShoppingRepositoryContract mockRepo;
  late GetCheckoutSessionUseCase useCase;

  const tRequestModel = PaymentRequestModel(
    street: 'Street 1',
    phone: '0102419753',
    city: 'Cairo',
    lat: '30.0',
    long: '31.0',
  );

  const tCheckoutSessionEntity = CheckoutSessionEntity(
    sessionId: 'sess_1',
    sessionUrl: 'https://checkout.stripe.com/session',
  );

  setUpAll(() {
    provideDummy<BaseResponse<CheckoutSessionEntity>>(
      SuccessBaseResponse(data: tCheckoutSessionEntity),
    );
  });

  setUp(() {
    mockRepo = MockShoppingRepositoryContract();
    useCase = GetCheckoutSessionUseCase(mockRepo);
  });

  test('returns SuccessBaseResponse with CheckoutSessionEntity on success', () async {
    when(mockRepo.createCheckoutSession(tRequestModel)).thenAnswer(
      (_) async => SuccessBaseResponse(data: tCheckoutSessionEntity),
    );

    final result = await useCase.execute(request: tRequestModel);

    expect(result, isA<SuccessBaseResponse<CheckoutSessionEntity>>());
    expect((result as SuccessBaseResponse).data, tCheckoutSessionEntity);
    verify(mockRepo.createCheckoutSession(tRequestModel)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('returns ErrorBaseResponse when repo returns an error', () async {
    final tException = Exception('Create checkout session failed');
    when(mockRepo.createCheckoutSession(tRequestModel)).thenAnswer(
      (_) async => ErrorBaseResponse(exception: tException),
    );

    final result = await useCase.execute(request: tRequestModel);

    expect(result, isA<ErrorBaseResponse<CheckoutSessionEntity>>());
    expect((result as ErrorBaseResponse).exception, tException);
    verify(mockRepo.createCheckoutSession(tRequestModel)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}

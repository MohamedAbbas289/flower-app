import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo_contract/cart_repo_contract.dart';
import 'package:flower_app/features/cart/domain/use_cases/get_cart_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_cart_use_case_test.mocks.dart';

@GenerateMocks([CartRepoContract])
void main() {
  late MockCartRepoContract mockCartRepoContract;
  late GetCartUseCase useCase;

  const tCartEntity = CartEntity(
    id: 'cart_1',
    cartItems: [],
    totalPrice: 100,
    totalPriceAfterDiscount: 90,
    discount: 10,
    numOfCartItems: 0,
  );

  setUp(() {
    mockCartRepoContract = MockCartRepoContract();
    useCase = GetCartUseCase(mockCartRepoContract);
    provideDummy<BaseResponse<CartEntity>>(
      SuccessBaseResponse(data: tCartEntity),
    );
  });

  test('returns SuccessBaseResponse with CartEntity on success', () async {
    when(
      mockCartRepoContract.getCart(),
    ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));

    final result = await useCase();

    expect(result, isA<SuccessBaseResponse<CartEntity>>());
    expect((result as SuccessBaseResponse).data, tCartEntity);
    verify(mockCartRepoContract.getCart()).called(1);
    verifyNoMoreInteractions(mockCartRepoContract);
  });

  test('returns ErrorBaseResponse when repo returns error', () async {
    final tException = Exception('Get cart failed');
    when(
      mockCartRepoContract.getCart(),
    ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

    final result = await useCase();

    expect(result, isA<ErrorBaseResponse<CartEntity>>());
    expect((result as ErrorBaseResponse).exception, tException);
    verify(mockCartRepoContract.getCart()).called(1);
    verifyNoMoreInteractions(mockCartRepoContract);
  });
}

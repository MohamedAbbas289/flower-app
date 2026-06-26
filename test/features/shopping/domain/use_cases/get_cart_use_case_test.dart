import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:flower_app/features/shopping/domain/use_cases/get_cart_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_cart_use_case_test.mocks.dart';

@GenerateMocks([ShoppingRepositoryContract])
void main() {
  late MockShoppingRepositoryContract mockShoppingRepositoryContract;
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
    mockShoppingRepositoryContract = MockShoppingRepositoryContract();
    useCase = GetCartUseCase(mockShoppingRepositoryContract);
    provideDummy<BaseResponse<CartEntity>>(
      SuccessBaseResponse(data: tCartEntity),
    );
  });

  test('returns SuccessBaseResponse with CartEntity on success', () async {
    when(
      mockShoppingRepositoryContract.getCart(),
    ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));

    final result = await useCase.execute();

    expect(result, isA<SuccessBaseResponse<CartEntity>>());
    expect((result as SuccessBaseResponse).data, tCartEntity);
    verify(mockShoppingRepositoryContract.getCart()).called(1);
    verifyNoMoreInteractions(mockShoppingRepositoryContract);
  });

  test('returns ErrorBaseResponse when repo returns error', () async {
    final tException = Exception('Get cart failed');
    when(
      mockShoppingRepositoryContract.getCart(),
    ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

    final result = await useCase.execute();

    expect(result, isA<ErrorBaseResponse<CartEntity>>());
    expect((result as ErrorBaseResponse).exception, tException);
    verify(mockShoppingRepositoryContract.getCart()).called(1);
    verifyNoMoreInteractions(mockShoppingRepositoryContract);
  });
}

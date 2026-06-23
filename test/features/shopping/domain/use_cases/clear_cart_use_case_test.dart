import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:flower_app/features/shopping/domain/use_cases/clear_cart_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'clear_cart_use_case_test.mocks.dart';

@GenerateMocks([ShoppingRepositoryContract])
void main() {
  late MockShoppingRepositoryContract mockShoppingRepositoryContract;
  late ClearCartUseCase useCase;

  const tEmptyCartEntity = CartEntity(
    id: '',
    cartItems: [],
    totalPrice: 0,
    totalPriceAfterDiscount: 0,
    discount: 0,
    numOfCartItems: 0,
  );

  setUp(() {
    mockShoppingRepositoryContract = MockShoppingRepositoryContract();
    useCase = ClearCartUseCase(mockShoppingRepositoryContract);
    provideDummy<BaseResponse<CartEntity>>(
      SuccessBaseResponse(data: tEmptyCartEntity),
    );
  });

  test('returns SuccessBaseResponse with CartEntity on success', () async {
    when(
      mockShoppingRepositoryContract.clearCart(),
    ).thenAnswer((_) async => SuccessBaseResponse(data: tEmptyCartEntity));

    final result = await useCase();

    expect(result, isA<SuccessBaseResponse<CartEntity>>());
    expect((result as SuccessBaseResponse).data, tEmptyCartEntity);
    verify(mockShoppingRepositoryContract.clearCart()).called(1);
    verifyNoMoreInteractions(mockShoppingRepositoryContract);
  });

  test('returns ErrorBaseResponse when repo returns error', () async {
    final tException = Exception('Clear cart failed');
    when(
      mockShoppingRepositoryContract.clearCart(),
    ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

    final result = await useCase();

    expect(result, isA<ErrorBaseResponse<CartEntity>>());
    expect((result as ErrorBaseResponse).exception, tException);
    verify(mockShoppingRepositoryContract.clearCart()).called(1);
    verifyNoMoreInteractions(mockShoppingRepositoryContract);
  });
}

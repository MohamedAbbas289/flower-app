import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo_contract/cart_repo_contract.dart';
import 'package:flower_app/features/cart/domain/use_cases/update_quantity_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_quantity_use_case_test.mocks.dart';

@GenerateMocks([CartRepoContract])
void main() {
  late MockCartRepoContract mockCartRepoContract;
  late UpdateQuantityUseCase useCase;

  const tRequestModel = CartRequestModel(productId: 'product_123', quantity: 2);

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
    useCase = UpdateQuantityUseCase(mockCartRepoContract);
    provideDummy<BaseResponse<CartEntity>>(
      SuccessBaseResponse(data: tCartEntity),
    );
  });

  test('returns SuccessBaseResponse with CartEntity on success', () async {
    when(
      mockCartRepoContract.updateQuantity(tRequestModel),
    ).thenAnswer((_) async => SuccessBaseResponse(data: tCartEntity));

    final result = await useCase(tRequestModel);

    expect(result, isA<SuccessBaseResponse<CartEntity>>());
    expect((result as SuccessBaseResponse).data, tCartEntity);
    verify(mockCartRepoContract.updateQuantity(tRequestModel)).called(1);
    verifyNoMoreInteractions(mockCartRepoContract);
  });

  test('returns ErrorBaseResponse when repo returns error', () async {
    final tException = Exception('Update quantity failed');
    when(
      mockCartRepoContract.updateQuantity(tRequestModel),
    ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

    final result = await useCase(tRequestModel);

    expect(result, isA<ErrorBaseResponse<CartEntity>>());
    expect((result as ErrorBaseResponse).exception, tException);
    verify(mockCartRepoContract.updateQuantity(tRequestModel)).called(1);
    verifyNoMoreInteractions(mockCartRepoContract);
  });
}

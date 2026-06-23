import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:flower_app/features/shopping/domain/use_cases/product_details_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'product_details_use_case_test.mocks.dart';

@GenerateMocks([ShoppingRepositoryContract])
void main() {
  late ProductDetailsUseCase useCase;
  late MockShoppingRepositoryContract mockRepo;

  const tProductId = '69d988754461df0f939b581a';

  final tEntity = ProductDetailsEntity(
    id: tProductId,
    title: 'Pink Rose Bouquet',
    description: 'Lorem ipsum',
    images: ['https://example.com/image.jpg'],
    price: 1500,
    priceAfterDiscount: 1200,
    quantity: 10,
    rateCount: 5,
    rateAvg: 4.5,
    isInWishlist: false,
  );

  setUpAll(() {
    provideDummy<BaseResponse<ProductDetailsEntity>>(
      SuccessBaseResponse<ProductDetailsEntity>(data: tEntity),
    );
    provideDummy<BaseResponse<ProductDetailsEntity>>(
      ErrorBaseResponse<ProductDetailsEntity>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockRepo = MockShoppingRepositoryContract();
    useCase = ProductDetailsUseCase(mockRepo);
  });

  group('getProductDetails', () {
    test('delegates to repo and returns SuccessBaseResponse', () async {
      when(
        mockRepo.getProductDetails(productId: anyNamed('productId')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      final result = await useCase.getProductDetails(productId: tProductId);

      expect(result, isA<SuccessBaseResponse<ProductDetailsEntity>>());
      expect(
        (result as SuccessBaseResponse<ProductDetailsEntity>).data,
        tEntity,
      );
      verify(mockRepo.getProductDetails(productId: tProductId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns ErrorBaseResponse when repo returns error', () async {
      when(
        mockRepo.getProductDetails(productId: anyNamed('productId')),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('error')),
      );

      final result = await useCase.getProductDetails(productId: tProductId);

      expect(result, isA<ErrorBaseResponse<ProductDetailsEntity>>());
      expect(
        (result as ErrorBaseResponse<ProductDetailsEntity>).errorMessage,
        isNotEmpty,
      );
      verify(mockRepo.getProductDetails(productId: tProductId)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}

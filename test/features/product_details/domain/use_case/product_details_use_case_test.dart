import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/product_details/domain/repo_contract/product_details_repo_contract.dart';
import 'package:flower_app/features/product_details/domain/use_case/product_details_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'product_details_use_case_test.mocks.dart';

@GenerateMocks([ProductDetailsRepoContract])
void main() {
  late ProductDetailsUseCase useCase;
  late MockProductDetailsRepoContract mockRepo;

  final tEntity = ProductDetailsEntity(
    id: '69d988754461df0f939b581a',
    title: 'Pink Rose Bouquet',
    description: 'Lorem ipsum',
    imgCover: 'https://example.com/image.jpg',
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
    mockRepo = MockProductDetailsRepoContract();
    useCase = ProductDetailsUseCase(mockRepo);
  });

  group('getProductDetails', () {
    test('delegates to repo and returns SuccessBaseResponse', () async {
      when(
        mockRepo.getProductDetails(),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      final result = await useCase.getProductDetails();

      expect(result, isA<SuccessBaseResponse<ProductDetailsEntity>>());
      expect(
        (result as SuccessBaseResponse<ProductDetailsEntity>).data,
        tEntity,
      );
      verify(mockRepo.getProductDetails()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns ErrorBaseResponse when repo returns error', () async {
      when(mockRepo.getProductDetails()).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('error')),
      );

      final result = await useCase.getProductDetails();

      expect(result, isA<ErrorBaseResponse<ProductDetailsEntity>>());
      expect(
        (result as ErrorBaseResponse<ProductDetailsEntity>).errorMessage,
        isNotEmpty,
      );
      verify(mockRepo.getProductDetails()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}

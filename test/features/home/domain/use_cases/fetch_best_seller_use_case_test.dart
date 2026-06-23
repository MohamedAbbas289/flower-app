import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/best_seller_product_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:flower_app/features/home/domain/use_cases/fetch_best_seller_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'fetch_best_seller_use_case_test.mocks.dart';

@GenerateMocks([HomeRepositoryContract])
void main() {
  late MockHomeRepositoryContract mockHomeRepositoryContract;
  late FetchBestSellerUseCase fetchBestSellerUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<BestSellerProductEntity>>>(
      SuccessBaseResponse<List<BestSellerProductEntity>>(data: const []),
    );
  });

  setUp(() {
    mockHomeRepositoryContract = MockHomeRepositoryContract();
    fetchBestSellerUseCase = FetchBestSellerUseCase(mockHomeRepositoryContract);
  });

  group('FetchBestSellerUseCase', () {
    test(
      'should return SuccessBaseResponse<List<BestSellerProductEntity>> when repository succeeds',
      () async {
        // Arrange
        final productEntity = BestSellerProductEntity(
          productId: "69d988754461df0f939b5817",
          title: "Wdding Flower",
          productPrice: 300,
          priceAfterDiscount: 100,
          discount: 60,
          imgCover:
              "https://flower.elevateegy.com/uploads/fefa790a-f0c1-42a0-8699-34e8fc065812-cover_image.png",
        );

        final successResponse =
            SuccessBaseResponse<List<BestSellerProductEntity>>(
              data: [productEntity],
            );

        when(
          mockHomeRepositoryContract.fetchBestSellers(),
        ).thenAnswer((_) async => successResponse);

        // Act
        final result = await fetchBestSellerUseCase.call();

        // Assert
        expect(
          result,
          isA<SuccessBaseResponse<List<BestSellerProductEntity>>>(),
        );

        final success =
            result as SuccessBaseResponse<List<BestSellerProductEntity>>;
        expect(success.data, isA<List<BestSellerProductEntity>>());
        expect(success.data.length, 1);
        expect(success.data.first.id, "69d988754461df0f939b5817");
        expect(success.data.first.title, "Wdding Flower");
        expect(success.data.first.price, 300);

        verify(mockHomeRepositoryContract.fetchBestSellers()).called(1);
        verifyNoMoreInteractions(mockHomeRepositoryContract);
      },
    );

    test(
      'should return ErrorBaseResponse<List<BestSellerProductEntity>> when repository fails',
      () async {
        // Arrange
        final exception = Exception("network error");
        final errorResponse = ErrorBaseResponse<List<BestSellerProductEntity>>(
          exception: exception,
        );

        when(
          mockHomeRepositoryContract.fetchBestSellers(),
        ).thenAnswer((_) async => errorResponse);

        // Act
        final result = await fetchBestSellerUseCase.call();

        // Assert
        expect(result, isA<ErrorBaseResponse<List<BestSellerProductEntity>>>());

        final error =
            result as ErrorBaseResponse<List<BestSellerProductEntity>>;
        expect(error.exception, exception);

        verify(mockHomeRepositoryContract.fetchBestSellers()).called(1);
        verifyNoMoreInteractions(mockHomeRepositoryContract);
      },
    );
  });
}

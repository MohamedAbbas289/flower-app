import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/best_seller/domain/entity/best_seller_product_entity.dart';
import 'package:flower_app/features/best_seller/domain/repo/best_seller_repo_contract.dart';
import 'package:flower_app/features/best_seller/domain/use_case/fetch_best_seller_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'fetch_best_seller_use_case_test.mocks.dart';

@GenerateMocks([BestSellerRepoContract])
void main() {
  late MockBestSellerRepoContract mockBestSellerRepo;
  late FetchBestSellerUseCase fetchBestSellerUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<BestSellerProductEntity>>>(
      SuccessBaseResponse<List<BestSellerProductEntity>>(data: const []),
    );
  });

  setUp(() {
    mockBestSellerRepo = MockBestSellerRepoContract();
    fetchBestSellerUseCase = FetchBestSellerUseCase(mockBestSellerRepo);
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
          mockBestSellerRepo.fetchBestSellers(),
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

        verify(mockBestSellerRepo.fetchBestSellers()).called(1);
        verifyNoMoreInteractions(mockBestSellerRepo);
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
          mockBestSellerRepo.fetchBestSellers(),
        ).thenAnswer((_) async => errorResponse);

        // Act
        final result = await fetchBestSellerUseCase.call();

        // Assert
        expect(result, isA<ErrorBaseResponse<List<BestSellerProductEntity>>>());

        final error =
            result as ErrorBaseResponse<List<BestSellerProductEntity>>;
        expect(error.exception, exception);

        verify(mockBestSellerRepo.fetchBestSellers()).called(1);
        verifyNoMoreInteractions(mockBestSellerRepo);
      },
    );
  });
}

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/best_seller/data/data_source/best_seller_remote_data_source_contract.dart';
import 'package:flower_app/features/best_seller/data/model/best_seller_product_model_dto.dart';
import 'package:flower_app/features/best_seller/data/model/best_seller_response.dart';
import 'package:flower_app/features/best_seller/data/repo/best_seller_repo_impl.dart';
import 'package:flower_app/features/best_seller/domain/entity/best_seller_product_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'best_seller_repo_impl_test.mocks.dart';

@GenerateMocks([BestSellerRemoteDataSourceContract])
void main() {
  late MockBestSellerRemoteDataSourceContract mockRemoteDataSource;
  late BestSellerRepoImpl bestSellerRepoImpl;

  setUpAll(() {
    provideDummy<BaseResponse<BestSellerResponse>>(
      SuccessBaseResponse(data: BestSellerResponse()),
    );
  });

  setUp(() {
    mockRemoteDataSource = MockBestSellerRemoteDataSourceContract();
    bestSellerRepoImpl = BestSellerRepoImpl(
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('BestSellerRepoImpl', () {
    final tProductModel = BestSellerProductModelDTO(
      id: "69d988754461df0f939b5817",
      title: "Wdding Flower",
      slug: "wdding-flower",
      description: "This is a Pack of White Widding Flowers",
      imgCover:
          "https://flower.elevateegy.com/uploads/fefa790a-f0c1-42a0-8699-34e8fc065812-cover_image.png",
      images: [
        "https://flower.elevateegy.com/uploads/66c36d5d-c067-46d9-b339-d81be57e0149-image_one.png",
      ],
      price: 300,
      priceAfterDiscount: 100,
      discount: 60,
      rateAvg: 0,
      rateCount: 0,
      sold: 37,
      quantity: 98,
      category: "69d988704461df0f939b57cc",
      occasion: "69d988724461df0f939b57ea",
    );

    test(
      'should return SuccessBaseResponse with mapped entities when datasource succeeds',
      () async {
        // Arrange
        final bestSellerResponse = BestSellerResponse(
          message: "success",
          bestSeller: [tProductModel],
        );

        final successResponse = SuccessBaseResponse<BestSellerResponse>(
          data: bestSellerResponse,
        );

        when(
          mockRemoteDataSource.fetchBestSellers(),
        ).thenAnswer((_) async => successResponse);

        // Act
        final result = await bestSellerRepoImpl.fetchBestSellers();

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
        expect(success.data.first.priceAfterDiscount, 100);
        expect(success.data.first.discount, 60);
        expect(success.data.first.imgCover, isNotEmpty);

        verify(mockRemoteDataSource.fetchBestSellers()).called(1);

        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return SuccessBaseResponse with empty list when bestSeller is null or empty',
      () async {
        // Arrange
        final bestSellerResponse = BestSellerResponse(
          message: "success",
          bestSeller: null,
        );

        final successResponse = SuccessBaseResponse<BestSellerResponse>(
          data: bestSellerResponse,
        );

        when(
          mockRemoteDataSource.fetchBestSellers(),
        ).thenAnswer((_) async => successResponse);

        // Act
        final result = await bestSellerRepoImpl.fetchBestSellers();

        // Assert
        expect(
          result,
          isA<SuccessBaseResponse<List<BestSellerProductEntity>>>(),
        );

        final success =
            result as SuccessBaseResponse<List<BestSellerProductEntity>>;
        expect(success.data, isEmpty);

        verify(mockRemoteDataSource.fetchBestSellers()).called(1);
      },
    );

    test('should return ErrorBaseResponse when datasource fails', () async {
      // Arrange
      final exception = Exception('Network error');
      final errorResponse = ErrorBaseResponse<BestSellerResponse>(
        exception: exception,
      );

      when(
        mockRemoteDataSource.fetchBestSellers(),
      ).thenAnswer((_) async => errorResponse);

      // Act
      final result = await bestSellerRepoImpl.fetchBestSellers();

      // Assert
      expect(result, isA<ErrorBaseResponse<List<BestSellerProductEntity>>>());

      final error = result as ErrorBaseResponse<List<BestSellerProductEntity>>;
      expect(error.exception, exception);

      verify(mockRemoteDataSource.fetchBestSellers()).called(1);

      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/data/data_source_contract/product_details_remote_data_source_contract.dart';
import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:flower_app/features/product_details/data/repo_impl/product_details_repo_impl.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'product_details_repo_impl_test.mocks.dart';

@GenerateMocks([ProductDetailsRemoteDataSourceContract])
void main() {
  late ProductDetailsRepoImpl repo;
  late MockProductDetailsRemoteDataSourceContract mockDataSource;

  const tProductId = '69d988754461df0f939b581a';

  final tProduct = Product(
    id: tProductId,
    title: 'Pink Rose Bouquet',
    description: 'Lorem ipsum',
    imgCover: 'https://example.com/cover.jpg',
    images: ['https://example.com/image.jpg'],
    price: 1500,
    priceAfterDiscount: 1200,
    quantity: 10,
    rateCount: 5,
    rateAvg: 4,
    isInWishlist: false,
  );

  final tResponse = ProductDetailsResponse(
    message: 'Success',
    products: [tProduct],
  );

  setUpAll(() {
    provideDummy<BaseResponse<ProductDetailsResponse>>(
      SuccessBaseResponse<ProductDetailsResponse>(data: tResponse),
    );
    provideDummy<BaseResponse<ProductDetailsResponse>>(
      ErrorBaseResponse<ProductDetailsResponse>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockDataSource = MockProductDetailsRemoteDataSourceContract();
    repo = ProductDetailsRepoImpl(mockDataSource);
  });

  group('getProductDetails', () {
    test('returns SuccessBaseResponse with entity on success', () async {
      when(
        mockDataSource.getProductDetails(productId: anyNamed('productId')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tResponse));

      final result = await repo.getProductDetails(productId: tProductId);

      expect(result, isA<SuccessBaseResponse<ProductDetailsEntity>>());
      final success = result as SuccessBaseResponse<ProductDetailsEntity>;
      expect(success.data.id, tProductId);
      expect(success.data.price, 1500);
    });

    test('returns ErrorBaseResponse on failure', () async {
      when(
        mockDataSource.getProductDetails(productId: anyNamed('productId')),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('network error')),
      );

      final result = await repo.getProductDetails(productId: tProductId);

      expect(result, isA<ErrorBaseResponse<ProductDetailsEntity>>());
    });
  });
}

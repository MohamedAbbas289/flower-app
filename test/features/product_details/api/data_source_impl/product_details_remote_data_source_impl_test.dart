import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/api/api_client/product_details_api_client.dart';
import 'package:flower_app/features/product_details/api/data_source_impl/product_details_remote_data_source_impl.dart';
import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'product_details_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProductDetailsApiClient])
void main() {
  late ProductDetailsRemoteDataSourceImpl dataSource;
  late MockProductDetailsApiClient mockApiClient;

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

  setUp(() {
    mockApiClient = MockProductDetailsApiClient();
    dataSource = ProductDetailsRemoteDataSourceImpl(mockApiClient);
  });

  group('getProductDetails', () {
    test('returns SuccessBaseResponse on success', () async {
      when(
        mockApiClient.getProductDetails(productId: anyNamed('productId')),
      ).thenAnswer((_) async => tResponse);

      final result = await dataSource.getProductDetails(productId: tProductId);

      expect(result, isA<SuccessBaseResponse<ProductDetailsResponse>>());
      final success = result as SuccessBaseResponse<ProductDetailsResponse>;
      expect(success.data.products?.first.id, tProductId);
    });

    test('returns ErrorBaseResponse on exception', () async {
      when(
        mockApiClient.getProductDetails(productId: anyNamed('productId')),
      ).thenThrow(Exception('network error'));

      final result = await dataSource.getProductDetails(productId: tProductId);

      expect(result, isA<ErrorBaseResponse<ProductDetailsResponse>>());
    });
  });
}

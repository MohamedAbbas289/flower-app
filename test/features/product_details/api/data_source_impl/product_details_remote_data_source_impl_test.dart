import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/api/api_client/product_details_api_client.dart';
import 'package:flower_app/features/product_details/api/data_source_impl/product_details_remote_data_source_impl.dart';
import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'product_details_remote_data_source_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProductDetailsApiClient>()])
void main() {
  late ProductDetailsRemoteDataSourceImpl productDetailsRemoteDataSourceImpl;
  late MockProductDetailsApiClient mockApiClient;

  final tResponse = ProductDetailsResponse(
    message: 'Success',
    product: Product(
      id: '69d988754461df0f939b581a',
      title: 'Pink Rose Bouquet',
      description: 'Lorem ipsum',
      imgCover: 'https://example.com/image.jpg',
      images: ['https://example.com/image.jpg'],
      price: 1500,
      priceAfterDiscount: 1200,
      quantity: 10,
      rateCount: 5,
      rateAvg: 4,
      isInWishlist: false,
    ),
  );

  setUp(() {
    mockApiClient = MockProductDetailsApiClient();
    productDetailsRemoteDataSourceImpl = ProductDetailsRemoteDataSourceImpl(
      mockApiClient,
    );
  });

  group('getProductDetails', () {
    test('returns SuccessBaseResponse on success', () async {
      when(
        mockApiClient.getProductDetails(),
      ).thenAnswer((_) async => tResponse);

      final result = await productDetailsRemoteDataSourceImpl
          .getProductDetails();

      expect(result, isA<SuccessBaseResponse<ProductDetailsResponse>>());

      final success = result as SuccessBaseResponse<ProductDetailsResponse>;
      expect(success.data.product?.id, '69d988754461df0f939b581a');
    });

    test('returns ErrorBaseResponse on exception', () async {
      when(
        mockApiClient.getProductDetails(),
      ).thenThrow(Exception('network error'));

      final result = await productDetailsRemoteDataSourceImpl
          .getProductDetails();

      expect(result, isA<ErrorBaseResponse<ProductDetailsResponse>>());
    });
  });
}

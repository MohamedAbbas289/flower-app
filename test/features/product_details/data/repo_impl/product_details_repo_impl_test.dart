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
  late ProductDetailsRepoImpl productDetailsRepoImpl;
  late MockProductDetailsRemoteDataSourceContract
  mockProductDetailsRemoteDataSourceContract;

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

  setUpAll(() {
    provideDummy<BaseResponse<ProductDetailsResponse>>(
      SuccessBaseResponse<ProductDetailsResponse>(data: tResponse),
    );
    provideDummy<BaseResponse<ProductDetailsResponse>>(
      ErrorBaseResponse<ProductDetailsResponse>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockProductDetailsRemoteDataSourceContract =
        MockProductDetailsRemoteDataSourceContract();
    productDetailsRepoImpl = ProductDetailsRepoImpl(
      mockProductDetailsRemoteDataSourceContract,
    );
  });

  group('getProductDetails', () {
    test('returns SuccessBaseResponse with entity on success', () async {
      when(
        mockProductDetailsRemoteDataSourceContract.getProductDetails(),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tResponse));

      final result = await productDetailsRepoImpl.getProductDetails();

      expect(result, isA<SuccessBaseResponse<ProductDetailsEntity>>());

      final success = result as SuccessBaseResponse<ProductDetailsEntity>;
      expect(success.data.id, '69d988754461df0f939b581a');
      expect(success.data.price, 1500);
    });

    test('returns ErrorBaseResponse on failure', () async {
      when(
        mockProductDetailsRemoteDataSourceContract.getProductDetails(),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('network error')),
      );

      final result = await productDetailsRepoImpl.getProductDetails();

      expect(result, isA<ErrorBaseResponse<ProductDetailsEntity>>());
    });
  });
}

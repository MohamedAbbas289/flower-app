import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/occasions/api/api_client/occasions_api_client.dart';
import 'package:flower_app/features/occasions/api/datasources_impl/occasions_remote_datasource_impl.dart';
import 'package:flower_app/features/occasions/data/models/occasions_response.dart'
    as occasions_model;
import 'package:flower_app/features/occasions/data/models/products_response.dart'
    as products_model;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occasions_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([OccasionsApiClient])
void main() {
  late MockOccasionsApiClient mockApiClient;
  late OccasionsDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockOccasionsApiClient();
    datasource = OccasionsDatasourceImpl(mockApiClient);
  });

  group('getOccasions', () {
    test('should return SuccessBaseResponse when api call succeeds', () async {
      final response = occasions_model.OccasionsResponse(
        message: 'success',
        metadata: occasions_model.Metadata(
          currentPage: 1,
          totalPages: 2,
          limit: 10,
          totalItems: 15,
        ),
        occasions: [
          occasions_model.Occasion(id: '1', name: 'Wedding', productsCount: 13),
        ],
      );

      when(mockApiClient.getOccasions(page: 1, limit: 10)).thenAnswer((
        _,
      ) async {
        return response;
      });

      final result = await datasource.getOccasions(page: 1, limit: 10);

      expect(
        result,
        isA<SuccessBaseResponse<occasions_model.OccasionsResponse>>(),
      );

      expect(
        (result as SuccessBaseResponse<occasions_model.OccasionsResponse>).data,
        response,
      );

      verify(mockApiClient.getOccasions(page: 1, limit: 10)).called(1);

      verifyNoMoreInteractions(mockApiClient);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      final exception = Exception('Server Error');

      when(mockApiClient.getOccasions(page: 1, limit: 10)).thenThrow(exception);

      final result = await datasource.getOccasions(page: 1, limit: 10);

      expect(
        result,
        isA<ErrorBaseResponse<occasions_model.OccasionsResponse>>(),
      );

      expect(
        (result as ErrorBaseResponse<occasions_model.OccasionsResponse>)
            .exception,
        exception,
      );
    });
  });

  group('getProductsByOccasion', () {
    test('should return SuccessBaseResponse when api call succeeds', () async {
      final response = products_model.ProductsResponse(
        message: 'success',
        metadata: products_model.Metadata(
          currentPage: 1,
          totalPages: 3,
          limit: 10,
          totalItems: 28,
        ),
        products: [
          products_model.Product(
            id: '1',
            title: 'Wedding Flower',
            imgCover: 'image.png',
            price: 300,
            priceAfterDiscount: 100,
            discount: 60,
          ),
        ],
      );

      when(
        mockApiClient.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).thenAnswer((_) async {
        return response;
      });

      final result = await datasource.getProductsByOccasion(
        occasionId: 'occasion_1',
        page: 1,
        limit: 10,
      );

      expect(
        result,
        isA<SuccessBaseResponse<products_model.ProductsResponse>>(),
      );

      expect(
        (result as SuccessBaseResponse<products_model.ProductsResponse>).data,
        response,
      );

      verify(
        mockApiClient.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).called(1);

      verifyNoMoreInteractions(mockApiClient);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      final exception = Exception('Server Error');

      when(
        mockApiClient.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).thenThrow(exception);

      final result = await datasource.getProductsByOccasion(
        occasionId: 'occasion_1',
        page: 1,
        limit: 10,
      );

      expect(result, isA<ErrorBaseResponse<products_model.ProductsResponse>>());

      expect(
        (result as ErrorBaseResponse<products_model.ProductsResponse>)
            .exception,
        exception,
      );
    });
  });
}

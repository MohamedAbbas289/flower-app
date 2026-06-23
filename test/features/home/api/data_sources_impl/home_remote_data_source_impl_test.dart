import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/api/api_client/home_api_client.dart';
import 'package:flower_app/features/home/api/data_sources_impl/home_remote_data_source_impl.dart';
import 'package:flower_app/features/home/data/models/best_seller_response.dart';
import 'package:flower_app/features/home/data/models/categories_response.dart';
import 'package:flower_app/features/home/data/models/category_products_response.dart';
import 'package:flower_app/features/home/data/models/occasion_products_response.dart'
    as products_model;
import 'package:flower_app/features/home/data/models/occasions_response.dart'
    as occasions_model;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([HomeApiClient])
void main() {
  late MockHomeApiClient mockHomeApiClient;
  late HomeRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHomeApiClient = MockHomeApiClient();
    dataSource = HomeRemoteDataSourceImpl(mockHomeApiClient);
  });

  group('fetchBestSellers', () {
    test('should return SuccessBaseResponse when api call succeeds', () async {
      final bestSellerResponse = BestSellerResponse();

      when(
        mockHomeApiClient.fetchBestSellers(),
      ).thenAnswer((_) async => bestSellerResponse);

      final result = await dataSource.fetchBestSellers();

      expect(result, isA<SuccessBaseResponse<BestSellerResponse>>());
      expect(
        (result as SuccessBaseResponse<BestSellerResponse>).data,
        bestSellerResponse,
      );
      verify(mockHomeApiClient.fetchBestSellers()).called(1);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      final exception = Exception('network error');

      when(mockHomeApiClient.fetchBestSellers()).thenThrow(exception);

      final result = await dataSource.fetchBestSellers();

      expect(result, isA<ErrorBaseResponse<BestSellerResponse>>());
      expect(
        (result as ErrorBaseResponse<BestSellerResponse>).exception,
        exception,
      );
      verify(mockHomeApiClient.fetchBestSellers()).called(1);
    });
  });

  group('getCategories', () {
    test('returns SuccessBaseResponse when api call succeeds', () async {
      const response = CategoriesResponse(message: 'Success');

      when(
        mockHomeApiClient.getCategories(page: 1, limit: 50),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getCategories(page: 1, limit: 50);

      expect(result, isA<SuccessBaseResponse<CategoriesResponse>>());
      expect(
        (result as SuccessBaseResponse<CategoriesResponse>).data,
        response,
      );
      verify(mockHomeApiClient.getCategories(page: 1, limit: 50)).called(1);
    });

    test('returns ErrorBaseResponse when api throws exception', () async {
      when(
        mockHomeApiClient.getCategories(page: 1, limit: 50),
      ).thenThrow(Exception('network error'));

      final result = await dataSource.getCategories(page: 1, limit: 50);

      expect(result, isA<ErrorBaseResponse<CategoriesResponse>>());
    });
  });

  group('getProductsByCategory', () {
    test('returns SuccessBaseResponse when api call succeeds', () async {
      const response = ProductsResponse(message: 'Success');

      when(
        mockHomeApiClient.getProductsByCategory(
          categoryId: '123',
          sort: null,
          page: 1,
          limit: 10,
        ),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getProductsByCategory(
        categoryId: '123',
        page: 1,
        limit: 10,
      );

      expect(result, isA<SuccessBaseResponse<ProductsResponse>>());
      expect(
        (result as SuccessBaseResponse<ProductsResponse>).data,
        response,
      );
      verify(
        mockHomeApiClient.getProductsByCategory(
          categoryId: '123',
          sort: null,
          page: 1,
          limit: 10,
        ),
      ).called(1);
    });

    test('returns ErrorBaseResponse when api throws exception', () async {
      when(
        mockHomeApiClient.getProductsByCategory(
          categoryId: '123',
          sort: null,
          page: 1,
          limit: 10,
        ),
      ).thenThrow(Exception('network error'));

      final result = await dataSource.getProductsByCategory(
        categoryId: '123',
        page: 1,
        limit: 10,
      );

      expect(result, isA<ErrorBaseResponse<ProductsResponse>>());
    });
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

      when(
        mockHomeApiClient.getOccasions(page: 1, limit: 10),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getOccasions(page: 1, limit: 10);

      expect(
        result,
        isA<SuccessBaseResponse<occasions_model.OccasionsResponse>>(),
      );
      expect(
        (result as SuccessBaseResponse<occasions_model.OccasionsResponse>)
            .data,
        response,
      );
      verify(mockHomeApiClient.getOccasions(page: 1, limit: 10)).called(1);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      final exception = Exception('Server Error');

      when(
        mockHomeApiClient.getOccasions(page: 1, limit: 10),
      ).thenThrow(exception);

      final result = await dataSource.getOccasions(page: 1, limit: 10);

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
      final response = products_model.OccasionProductsResponse(
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
        mockHomeApiClient.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getProductsByOccasion(
        occasionId: 'occasion_1',
        page: 1,
        limit: 10,
      );

      expect(
        result,
        isA<SuccessBaseResponse<products_model.OccasionProductsResponse>>(),
      );
      expect(
        (result
                as SuccessBaseResponse<products_model.OccasionProductsResponse>)
            .data,
        response,
      );
      verify(
        mockHomeApiClient.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).called(1);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      final exception = Exception('Server Error');

      when(
        mockHomeApiClient.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).thenThrow(exception);

      final result = await dataSource.getProductsByOccasion(
        occasionId: 'occasion_1',
        page: 1,
        limit: 10,
      );

      expect(
        result,
        isA<ErrorBaseResponse<products_model.OccasionProductsResponse>>(),
      );
      expect(
        (result
                as ErrorBaseResponse<products_model.OccasionProductsResponse>)
            .exception,
        exception,
      );
    });
  });

  group('searchProducts', () {
    test('returns SuccessBaseResponse when api call succeeds', () async {
      const response = ProductsResponse(message: 'Success');

      when(
        mockHomeApiClient.searchProducts(query: 'rose'),
      ).thenAnswer((_) async => response);

      final result = await dataSource.searchProducts(query: 'rose');

      expect(result, isA<SuccessBaseResponse<ProductsResponse>>());
      expect(
        (result as SuccessBaseResponse<ProductsResponse>).data,
        response,
      );
      verify(mockHomeApiClient.searchProducts(query: 'rose')).called(1);
    });

    test('returns ErrorBaseResponse when api throws exception', () async {
      when(
        mockHomeApiClient.searchProducts(query: 'rose'),
      ).thenThrow(Exception('network error'));

      final result = await dataSource.searchProducts(query: 'rose');

      expect(result, isA<ErrorBaseResponse<ProductsResponse>>());
    });
  });
}

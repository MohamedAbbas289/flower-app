import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/categories_api_client/categories_api_client.dart';
import 'package:flower_app/features/categories/api/data_sources/categories_remote_data_source_impl.dart';
import 'package:flower_app/features/categories/api/responses/categories_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'categories_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CategoriesApiClient])
void main() {
  late MockCategoriesApiClient mockApiClient;
  late CategoriesRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockCategoriesApiClient();
    dataSource = CategoriesRemoteDataSourceImpl(mockApiClient);
  });

  group('CategoriesRemoteDataSourceImpl', () {
    test('getCategories returns SuccessBaseResponse when api call succeeds',
            () async {
          const response = CategoriesResponse(message: 'Success');

          when(mockApiClient.getCategories(page: 1, limit: 50))
              .thenAnswer((_) async => response);

          final result = await dataSource.getCategories(page: 1, limit: 50);

          expect(result, isA<SuccessBaseResponse<CategoriesResponse>>());
          expect(
            (result as SuccessBaseResponse<CategoriesResponse>).data,
            response,
          );
          verify(mockApiClient.getCategories(page: 1, limit: 50)).called(1);
        });

    test('getCategories returns ErrorBaseResponse when api throws exception',
            () async {
          when(mockApiClient.getCategories(page: 1, limit: 50))
              .thenThrow(Exception('network error'));

          final result = await dataSource.getCategories(page: 1, limit: 50);

          expect(result, isA<ErrorBaseResponse<CategoriesResponse>>());
        });

    test(
        'getProductsByCategory returns SuccessBaseResponse when api call succeeds',
            () async {
          const response = ProductsResponse(message: 'Success');

          when(mockApiClient.getProductsByCategory(
              categoryId: '123', page: 1, limit: 10))
              .thenAnswer((_) async => response);

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
            mockApiClient.getProductsByCategory(
                categoryId: '123', page: 1, limit: 10),
          ).called(1);
        });

    test(
        'getProductsByCategory returns ErrorBaseResponse when api throws exception',
            () async {
          when(mockApiClient.getProductsByCategory(
              categoryId: '123', page: 1, limit: 10))
              .thenThrow(Exception('network error'));

          final result = await dataSource.getProductsByCategory(
            categoryId: '123',
            page: 1,
            limit: 10,
          );

          expect(result, isA<ErrorBaseResponse<ProductsResponse>>());
        });
  });
}

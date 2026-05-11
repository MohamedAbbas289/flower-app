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
  late MockCategoriesApiClient mockCategoriesApiClient;
  late CategoriesRemoteDataSourceImpl categoriesRemoteDataSourceImpl;

  setUp(() {
    mockCategoriesApiClient = MockCategoriesApiClient();
    categoriesRemoteDataSourceImpl = CategoriesRemoteDataSourceImpl(
      mockCategoriesApiClient,
    );
  });

  group('CategoriesRemoteDataSourceImpl', () {
    test(
      'getCategories should return CategoriesResponse when api call succeeds',
      () async {
        const response = CategoriesResponse(message: "Success");

        when(
          mockCategoriesApiClient.getCategories(),
        ).thenAnswer((_) async => response);

        final result = await categoriesRemoteDataSourceImpl.getCategories();

        expect(result, isA<CategoriesResponse>());
        expect(result, response);
        verify(mockCategoriesApiClient.getCategories()).called(1);
      },
    );

    test(
      'getCategories should throw exception when api throws exception',
      () async {
        final exception = Exception('network error');

        when(mockCategoriesApiClient.getCategories()).thenThrow(exception);

        expect(
          () => categoriesRemoteDataSourceImpl.getCategories(),
          throwsException,
        );
        verify(mockCategoriesApiClient.getCategories()).called(1);
      },
    );

    test(
      'getProductsByCategory should return ProductsResponse when api call succeeds',
      () async {
        const response = ProductsResponse(message: "Success");

        when(
          mockCategoriesApiClient.getProductsByCategory(categoryId: "123"),
        ).thenAnswer((_) async => response);

        final result = await categoriesRemoteDataSourceImpl
            .getProductsByCategory(categoryId: "123");

        expect(result, isA<ProductsResponse>());
        expect(result, response);
        verify(
          mockCategoriesApiClient.getProductsByCategory(categoryId: "123"),
        ).called(1);
      },
    );

    test(
      'getProductsByCategory should throw exception when api throws exception',
      () async {
        final exception = Exception('network error');

        when(
          mockCategoriesApiClient.getProductsByCategory(categoryId: "123"),
        ).thenThrow(exception);

        expect(
          () => categoriesRemoteDataSourceImpl.getProductsByCategory(
            categoryId: "123",
          ),
          throwsException,
        );
        verify(
          mockCategoriesApiClient.getProductsByCategory(categoryId: "123"),
        ).called(1);
      },
    );
  });
}

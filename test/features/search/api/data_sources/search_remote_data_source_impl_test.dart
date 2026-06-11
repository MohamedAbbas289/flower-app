import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/search/api/data_sources/search_remote_data_source_impl.dart';
import 'package:flower_app/features/search/api/search_api_client/search_api_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([SearchApiClient])
void main() {
  late MockSearchApiClient mockApiClient;
  late SearchRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockSearchApiClient();
    dataSource = SearchRemoteDataSourceImpl(mockApiClient);
  });

  group('SearchRemoteDataSourceImpl', () {
    test(
      'searchProducts returns SuccessBaseResponse when api call succeeds',
      () async {
        const response = ProductsResponse(message: 'Success');

        when(
          mockApiClient.searchProducts(query: 'rose'),
        ).thenAnswer((_) async => response);

        final result = await dataSource.searchProducts(query: 'rose');

        expect(result, isA<SuccessBaseResponse<ProductsResponse>>());
        expect(
          (result as SuccessBaseResponse<ProductsResponse>).data,
          response,
        );
        verify(mockApiClient.searchProducts(query: 'rose')).called(1);
      },
    );

    test(
      'searchProducts returns ErrorBaseResponse when api throws exception',
      () async {
        when(
          mockApiClient.searchProducts(query: 'rose'),
        ).thenThrow(Exception('network error'));

        final result = await dataSource.searchProducts(query: 'rose');

        expect(result, isA<ErrorBaseResponse<ProductsResponse>>());
      },
    );
  });
}

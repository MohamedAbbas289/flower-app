import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/metadata_model.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:flower_app/features/search/data/repository/search_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_repository_impl_test.mocks.dart';

@GenerateMocks([SearchRemoteDataSource])
void main() {
  late MockSearchRemoteDataSource mockDataSource;
  late SearchRepositoryImpl repository;

  setUpAll(() {
    provideDummy<BaseResponse<ProductsResponse>>(
      SuccessBaseResponse<ProductsResponse>(data: const ProductsResponse()),
    );
    provideDummy<BaseResponse<ProductsResponseEntity>>(
      SuccessBaseResponse<ProductsResponseEntity>(
        data: const ProductsResponseEntity(products: []),
      ),
    );
  });

  setUp(() {
    mockDataSource = MockSearchRemoteDataSource();
    repository = SearchRepositoryImpl(mockDataSource);
  });

  group('SearchRepositoryImpl', () {
    test(
      'searchProducts returns SuccessBaseResponse<ProductsResponseEntity> when datasource succeeds',
      () async {
        const productModel = ProductModel(id: '1', title: 'Red Rose');
        const metadataModel = MetadataModel(
          currentPage: 1,
          totalPages: 2,
          limit: 40,
        );
        const response = ProductsResponse(
          products: [productModel],
          metadata: metadataModel,
        );

        when(
          mockDataSource.searchProducts(query: 'rose'),
        ).thenAnswer((_) async => SuccessBaseResponse(data: response));

        final result = await repository.searchProducts(query: 'rose');

        expect(result, isA<SuccessBaseResponse<ProductsResponseEntity>>());
        final success = result as SuccessBaseResponse<ProductsResponseEntity>;
        expect(success.data.products.length, 1);
        expect(success.data.products.first.id, '1');
        expect(success.data.metadata?.currentPage, 1);
        verify(mockDataSource.searchProducts(query: 'rose')).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'searchProducts returns ErrorBaseResponse<ProductsResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(
          mockDataSource.searchProducts(query: 'rose'),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: exception));

        final result = await repository.searchProducts(query: 'rose');

        expect(result, isA<ErrorBaseResponse<ProductsResponseEntity>>());
        verify(mockDataSource.searchProducts(query: 'rose')).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });
}

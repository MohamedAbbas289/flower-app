import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/search/domain/repository/search_repository.dart';
import 'package:flower_app/features/search/domain/use_cases/search_products_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_products_use_case_test.mocks.dart';

@GenerateMocks([SearchRepository])
void main() {
  late MockSearchRepository mockSearchRepository;
  late SearchProductsUseCase searchProductsUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<ProductsResponseEntity>>(
      SuccessBaseResponse<ProductsResponseEntity>(
        data: const ProductsResponseEntity(products: []),
      ),
    );
  });

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    searchProductsUseCase = SearchProductsUseCase(mockSearchRepository);
  });

  group('SearchProductsUseCase', () {
    test(
      'should return SuccessBaseResponse<ProductsResponseEntity> when repository succeeds',
      () async {
        final successResponse = SuccessBaseResponse<ProductsResponseEntity>(
          data: const ProductsResponseEntity(
            products: [ProductEntity(id: '1')],
          ),
        );

        when(
          mockSearchRepository.searchProducts(query: 'rose'),
        ).thenAnswer((_) async => successResponse);

        final result = await searchProductsUseCase.execute(query: 'rose');

        expect(result, isA<SuccessBaseResponse<ProductsResponseEntity>>());
        final success = result as SuccessBaseResponse<ProductsResponseEntity>;
        expect(success.data.products.length, 1);
        expect(success.data.products.first.id, '1');
        verify(mockSearchRepository.searchProducts(query: 'rose')).called(1);
        verifyNoMoreInteractions(mockSearchRepository);
      },
    );

    test(
      'should return ErrorBaseResponse<ProductsResponseEntity> when repository fails',
      () async {
        final exception = Exception('network error');
        final errorResponse = ErrorBaseResponse<ProductsResponseEntity>(
          exception: exception,
        );

        when(
          mockSearchRepository.searchProducts(query: 'rose'),
        ).thenAnswer((_) async => errorResponse);

        final result = await searchProductsUseCase.execute(query: 'rose');

        expect(result, isA<ErrorBaseResponse<ProductsResponseEntity>>());
        final error = result as ErrorBaseResponse<ProductsResponseEntity>;
        expect(error.exception, exception);
        verify(mockSearchRepository.searchProducts(query: 'rose')).called(1);
        verifyNoMoreInteractions(mockSearchRepository);
      },
    );
  });
}

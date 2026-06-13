import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/metadata_model.dart';
import 'package:flower_app/features/categories/api/responses/categories_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:flower_app/features/categories/data/models/category_model.dart';
import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:flower_app/features/categories/data/repository/categories_repository_impl.dart';
import 'package:flower_app/features/categories/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'categories_repository_impl_test.mocks.dart';

@GenerateMocks([CategoriesRemoteDataSource])
void main() {
  late MockCategoriesRemoteDataSource mockDataSource;
  late CategoriesRepositoryImpl repository;

  setUpAll(() {
    provideDummy<BaseResponse<CategoriesResponse>>(
      SuccessBaseResponse<CategoriesResponse>(
        data: const CategoriesResponse(),
      ),
    );
    provideDummy<BaseResponse<ProductsResponse>>(
      SuccessBaseResponse<ProductsResponse>(
        data: const ProductsResponse(),
      ),
    );
    provideDummy<BaseResponse<CategoriesResponseEntity>>(
      SuccessBaseResponse<CategoriesResponseEntity>(
        data: const CategoriesResponseEntity(categories: []),
      ),
    );
    provideDummy<BaseResponse<ProductsResponseEntity>>(
      SuccessBaseResponse<ProductsResponseEntity>(
        data: const ProductsResponseEntity(products: []),
      ),
    );
  });

  setUp(() {
    mockDataSource = MockCategoriesRemoteDataSource();
    repository = CategoriesRepositoryImpl(mockDataSource);
  });

  group('CategoriesRepositoryImpl', () {
    test(
      'getCategories returns SuccessBaseResponse<CategoriesResponseEntity> when datasource succeeds',
      () async {
        const categoryModel = CategoryModel(id: '1', name: 'flowers');
        const metadataModel = MetadataModel(
            currentPage: 1, totalPages: 2, limit: 10);
        const response = CategoriesResponse(
          categories: [categoryModel],
          metadata: metadataModel,
        );

        when(mockDataSource.getCategories(page: 1, limit: 50))
            .thenAnswer((_) async => SuccessBaseResponse(data: response));

        final result = await repository.getCategories(page: 1, limit: 50);

        expect(result, isA<SuccessBaseResponse<CategoriesResponseEntity>>());
        final success = result as SuccessBaseResponse<CategoriesResponseEntity>;
        expect(success.data.categories.length, 1);
        expect(success.data.categories.first.id, '1');
        expect(success.data.metadata?.currentPage, 1);
        verify(mockDataSource.getCategories(page: 1, limit: 50)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'getCategories returns ErrorBaseResponse<CategoriesResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(mockDataSource.getCategories(page: 1, limit: 50))
            .thenAnswer((_) async => ErrorBaseResponse(exception: exception));

        final result = await repository.getCategories(page: 1, limit: 50);

        expect(result, isA<ErrorBaseResponse<CategoriesResponseEntity>>());
        verify(mockDataSource.getCategories(page: 1, limit: 50)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'getProductsByCategory returns SuccessBaseResponse<ProductsResponseEntity> when datasource succeeds',
      () async {
        const productModel = ProductModel(id: '1', title: 'product 1');
        const metadataModel = MetadataModel(
            currentPage: 1, totalPages: 2, limit: 10);
        const response = ProductsResponse(
          products: [productModel],
          metadata: metadataModel,
        );

        when(mockDataSource.getProductsByCategory(
            categoryId: '123', sort: null, page: 1, limit: 10))
            .thenAnswer((_) async => SuccessBaseResponse(data: response));

        final result = await repository.getProductsByCategory(
          categoryId: '123',
          page: 1,
          limit: 10,
        );

        expect(result, isA<SuccessBaseResponse<ProductsResponseEntity>>());
        final success = result as SuccessBaseResponse<ProductsResponseEntity>;
        expect(success.data.products.length, 1);
        expect(success.data.products.first.id, '1');
        expect(success.data.metadata?.currentPage, 1);
        verify(mockDataSource.getProductsByCategory(
            categoryId: '123', sort: null, page: 1, limit: 10))
            .called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'getProductsByCategory returns ErrorBaseResponse<ProductsResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(mockDataSource.getProductsByCategory(
            categoryId: '123', sort: null, page: 1, limit: 10))
            .thenAnswer((_) async => ErrorBaseResponse(exception: exception));

        final result = await repository.getProductsByCategory(
          categoryId: '123',
          page: 1,
          limit: 10,
        );

        expect(result, isA<ErrorBaseResponse<ProductsResponseEntity>>());
        verify(mockDataSource.getProductsByCategory(
            categoryId: '123', sort: null, page: 1, limit: 10))
            .called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });
}

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
  late MockCategoriesRemoteDataSource mockCategoriesRemoteDataSource;
  late CategoriesRepositoryImpl categoriesRepositoryImpl;

  setUpAll(() {
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
    mockCategoriesRemoteDataSource = MockCategoriesRemoteDataSource();
    categoriesRepositoryImpl = CategoriesRepositoryImpl(
      mockCategoriesRemoteDataSource,
    );
  });

  group('CategoriesRepositoryImpl', () {
    test(
      'getCategories should return SuccessBaseResponse<CategoriesResponseEntity> when datasource succeeds',
      () async {
        const categoryModel = CategoryModel(id: "1", name: "flowers");
        const metadataModel = MetadataModel(
            currentPage: 1, totalPages: 2, limit: 10);
        const response = CategoriesResponse(
            categories: [categoryModel], metadata: metadataModel);

        when(mockCategoriesRemoteDataSource.getCategories(page: 1, limit: 10))
            .thenAnswer((_) async => response);

        final result = await categoriesRepositoryImpl.getCategories(
            page: 1, limit: 10);

        expect(result, isA<SuccessBaseResponse<CategoriesResponseEntity>>());
        final success = result as SuccessBaseResponse<CategoriesResponseEntity>;
        expect(success.data.categories.length, 1);
        expect(success.data.categories.first.id, "1");
        expect(success.data.metadata?.currentPage, 1);
        verify(mockCategoriesRemoteDataSource.getCategories(page: 1, limit: 10))
            .called(1);
        verifyNoMoreInteractions(mockCategoriesRemoteDataSource);
      },
    );

    test(
      'getCategories should return ErrorBaseResponse<CategoriesResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(mockCategoriesRemoteDataSource.getCategories(
            page: null, limit: null))
            .thenThrow(exception);

        final result = await categoriesRepositoryImpl.getCategories();

        expect(result, isA<ErrorBaseResponse<CategoriesResponseEntity>>());
        final error = result as ErrorBaseResponse<CategoriesResponseEntity>;
        expect(error.exception, exception);
        verify(mockCategoriesRemoteDataSource.getCategories(
            page: null, limit: null)).called(1);
        verifyNoMoreInteractions(mockCategoriesRemoteDataSource);
      },
    );

    test(
      'getProductsByCategory should return SuccessBaseResponse<ProductsResponseEntity> when datasource succeeds',
      () async {
        const productModel = ProductModel(id: "1", title: "product 1");
        const metadataModel = MetadataModel(
            currentPage: 1, totalPages: 2, limit: 10);
        const response = ProductsResponse(
            products: [productModel], metadata: metadataModel);

        when(mockCategoriesRemoteDataSource.getProductsByCategory(
            categoryId: "123", page: 1, limit: 10))
            .thenAnswer((_) async => response);

        final result = await categoriesRepositoryImpl.getProductsByCategory(
            categoryId: "123", page: 1, limit: 10);

        expect(result, isA<SuccessBaseResponse<ProductsResponseEntity>>());
        final success = result as SuccessBaseResponse<ProductsResponseEntity>;
        expect(success.data.products.length, 1);
        expect(success.data.products.first.id, "1");
        expect(success.data.metadata?.currentPage, 1);
        verify(mockCategoriesRemoteDataSource.getProductsByCategory(
            categoryId: "123", page: 1, limit: 10)).called(1);
        verifyNoMoreInteractions(mockCategoriesRemoteDataSource);
      },
    );

    test(
      'getProductsByCategory should return ErrorBaseResponse<ProductsResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(mockCategoriesRemoteDataSource.getProductsByCategory(
            categoryId: "123", page: null, limit: null))
            .thenThrow(exception);

        final result = await categoriesRepositoryImpl.getProductsByCategory(
            categoryId: "123");

        expect(result, isA<ErrorBaseResponse<ProductsResponseEntity>>());
        final error = result as ErrorBaseResponse<ProductsResponseEntity>;
        expect(error.exception, exception);
        verify(mockCategoriesRemoteDataSource.getProductsByCategory(
            categoryId: "123", page: null, limit: null)).called(1);
        verifyNoMoreInteractions(mockCategoriesRemoteDataSource);
      },
    );
  });
}

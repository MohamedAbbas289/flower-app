import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/responses/categories_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:flower_app/features/categories/data/models/category_model.dart';
import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:flower_app/features/categories/data/repository/categories_repository_impl.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'categories_repository_impl_test.mocks.dart';

@GenerateMocks([CategoriesRemoteDataSource])
void main() {
  late MockCategoriesRemoteDataSource mockCategoriesRemoteDataSource;
  late CategoriesRepositoryImpl categoriesRepositoryImpl;

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>(data: []),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse<List<ProductEntity>>(data: []),
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
      'getCategories should return SuccessBaseResponse<List<CategoryEntity>> when datasource succeeds',
      () async {
        const categoryModel = CategoryModel(id: "1", name: "flowers");
        const response = CategoriesResponse(categories: [categoryModel]);

        when(
          mockCategoriesRemoteDataSource.getCategories(),
        ).thenAnswer((_) async => response);

        final result = await categoriesRepositoryImpl.getCategories();

        expect(result, isA<SuccessBaseResponse<List<CategoryEntity>>>());
        final success = result as SuccessBaseResponse<List<CategoryEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, "1");
        expect(success.data.first.name, "flowers");
        verify(mockCategoriesRemoteDataSource.getCategories()).called(1);
        verifyNoMoreInteractions(mockCategoriesRemoteDataSource);
      },
    );

    test(
      'getCategories should return ErrorBaseResponse<List<CategoryEntity>> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(
          mockCategoriesRemoteDataSource.getCategories(),
        ).thenThrow(exception);

        final result = await categoriesRepositoryImpl.getCategories();

        expect(result, isA<ErrorBaseResponse<List<CategoryEntity>>>());
        final error = result as ErrorBaseResponse<List<CategoryEntity>>;
        expect(error.exception, exception);
        verify(mockCategoriesRemoteDataSource.getCategories()).called(1);
        verifyNoMoreInteractions(mockCategoriesRemoteDataSource);
      },
    );

    test(
      'getProductsByCategory should return SuccessBaseResponse<List<ProductEntity>> when datasource succeeds',
      () async {
        const productModel = ProductModel(id: "1", title: "product 1");
        const response = ProductsResponse(products: [productModel]);

        when(
          mockCategoriesRemoteDataSource.getProductsByCategory(
            categoryId: "123",
          ),
        ).thenAnswer((_) async => response);

        final result = await categoriesRepositoryImpl.getProductsByCategory(
          categoryId: "123",
        );

        expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
        final success = result as SuccessBaseResponse<List<ProductEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, "1");
        expect(success.data.first.title, "product 1");
        verify(
          mockCategoriesRemoteDataSource.getProductsByCategory(
            categoryId: "123",
          ),
        ).called(1);
        verifyNoMoreInteractions(mockCategoriesRemoteDataSource);
      },
    );

    test(
      'getProductsByCategory should return ErrorBaseResponse<List<ProductEntity>> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(
          mockCategoriesRemoteDataSource.getProductsByCategory(
            categoryId: "123",
          ),
        ).thenThrow(exception);

        final result = await categoriesRepositoryImpl.getProductsByCategory(
          categoryId: "123",
        );

        expect(result, isA<ErrorBaseResponse<List<ProductEntity>>>());
        final error = result as ErrorBaseResponse<List<ProductEntity>>;
        expect(error.exception, exception);
        verify(
          mockCategoriesRemoteDataSource.getProductsByCategory(
            categoryId: "123",
          ),
        ).called(1);
        verifyNoMoreInteractions(mockCategoriesRemoteDataSource);
      },
    );
  });
}

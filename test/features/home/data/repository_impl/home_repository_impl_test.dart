import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/metadata_model.dart';
import 'package:flower_app/features/home/data/data_sources_contract/home_remote_data_source_contract.dart';
import 'package:flower_app/features/home/data/models/best_seller_product_model_dto.dart';
import 'package:flower_app/features/home/data/models/best_seller_response.dart';
import 'package:flower_app/features/home/data/models/categories_response.dart';
import 'package:flower_app/features/home/data/models/category_model.dart';
import 'package:flower_app/features/home/data/models/category_products_response.dart';
import 'package:flower_app/features/home/data/models/home_best_seller_dto.dart';
import 'package:flower_app/features/home/data/models/home_category_dto.dart';
import 'package:flower_app/features/home/data/models/home_occasion_dto.dart';
import 'package:flower_app/features/home/data/models/occasion_products_response.dart'
    as products_model;
import 'package:flower_app/features/home/data/models/occasions_response.dart'
    as occasions_model;
import 'package:flower_app/features/home/data/models/product_model.dart';
import 'package:flower_app/features/home/data/repository_impl/home_repository_impl.dart';
import 'package:flower_app/features/home/domain/entities/best_seller_product_entity.dart';
import 'package:flower_app/features/home/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_best_seller_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_category_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_occasion_entity.dart';
import 'package:flower_app/features/home/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_entity.dart'
    hide ProductEntity;
import 'package:flower_app/features/home/domain/entities/products_entity.dart'
    as occasion_entities
    show ProductEntity;
import 'package:flower_app/features/home/domain/entities/products_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateMocks([HomeRemoteDataSourceContract])
void main() {
  late MockHomeRemoteDataSourceContract mockDataSource;
  late HomeRepositoryImpl repo;

  setUpAll(() {
    provideDummy<BaseResponse<BestSellerResponse>>(
      SuccessBaseResponse(data: BestSellerResponse()),
    );
    provideDummy<BaseResponse<CategoriesResponse>>(
      SuccessBaseResponse<CategoriesResponse>(
        data: const CategoriesResponse(),
      ),
    );
    provideDummy<BaseResponse<ProductsResponse>>(
      SuccessBaseResponse<ProductsResponse>(data: const ProductsResponse()),
    );
    provideDummy<BaseResponse<List<CategoryDto>>>(
      SuccessBaseResponse<List<CategoryDto>>(data: []),
    );
    provideDummy<BaseResponse<List<OccasionDto>>>(
      SuccessBaseResponse<List<OccasionDto>>(data: []),
    );
    provideDummy<BaseResponse<List<BestSellerDto>>>(
      SuccessBaseResponse<List<BestSellerDto>>(data: []),
    );
    provideDummy<BaseResponse<occasions_model.OccasionsResponse>>(
      SuccessBaseResponse<occasions_model.OccasionsResponse>(
        data: occasions_model.OccasionsResponse(),
      ),
    );
    provideDummy<BaseResponse<products_model.OccasionProductsResponse>>(
      SuccessBaseResponse<products_model.OccasionProductsResponse>(
        data: products_model.OccasionProductsResponse(),
      ),
    );
  });

  setUp(() {
    mockDataSource = MockHomeRemoteDataSourceContract();
    repo = HomeRepositoryImpl(mockDataSource);
  });

  group('fetchBestSellers', () {
    final tProductModel = BestSellerProductModelDTO(
      id: "69d988754461df0f939b5817",
      title: "Wdding Flower",
      slug: "wdding-flower",
      description: "This is a Pack of White Widding Flowers",
      imgCover:
          "https://flower.elevateegy.com/uploads/fefa790a-f0c1-42a0-8699-34e8fc065812-cover_image.png",
      images: [
        "https://flower.elevateegy.com/uploads/66c36d5d-c067-46d9-b339-d81be57e0149-image_one.png",
      ],
      price: 300,
      priceAfterDiscount: 100,
      discount: 60,
      rateAvg: 0,
      rateCount: 0,
      sold: 37,
      quantity: 98,
      category: "69d988704461df0f939b57cc",
      occasion: "69d988724461df0f939b57ea",
    );

    test(
      'returns SuccessBaseResponse with mapped entities when datasource succeeds',
      () async {
        final bestSellerResponse = BestSellerResponse(
          message: "success",
          bestSeller: [tProductModel],
        );

        when(mockDataSource.fetchBestSellers()).thenAnswer(
          (_) async =>
              SuccessBaseResponse<BestSellerResponse>(data: bestSellerResponse),
        );

        final result = await repo.fetchBestSellers();

        expect(
          result,
          isA<SuccessBaseResponse<List<BestSellerProductEntity>>>(),
        );
        final success =
            result as SuccessBaseResponse<List<BestSellerProductEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, "69d988754461df0f939b5817");
        expect(success.data.first.title, "Wdding Flower");
        verify(mockDataSource.fetchBestSellers()).called(1);
      },
    );

    test(
      'returns SuccessBaseResponse with empty list when bestSeller is null',
      () async {
        final bestSellerResponse = BestSellerResponse(
          message: "success",
          bestSeller: null,
        );

        when(mockDataSource.fetchBestSellers()).thenAnswer(
          (_) async =>
              SuccessBaseResponse<BestSellerResponse>(data: bestSellerResponse),
        );

        final result = await repo.fetchBestSellers();

        expect(
          result,
          isA<SuccessBaseResponse<List<BestSellerProductEntity>>>(),
        );
        final success =
            result as SuccessBaseResponse<List<BestSellerProductEntity>>;
        expect(success.data, isEmpty);
        verify(mockDataSource.fetchBestSellers()).called(1);
      },
    );

    test('returns ErrorBaseResponse when datasource fails', () async {
      final exception = Exception('Network error');

      when(mockDataSource.fetchBestSellers()).thenAnswer(
        (_) async => ErrorBaseResponse<BestSellerResponse>(exception: exception),
      );

      final result = await repo.fetchBestSellers();

      expect(result, isA<ErrorBaseResponse<List<BestSellerProductEntity>>>());
      verify(mockDataSource.fetchBestSellers()).called(1);
    });
  });

  group('getCategories', () {
    test(
      'returns SuccessBaseResponse<CategoriesResponseEntity> when datasource succeeds',
      () async {
        const categoryModel = CategoryModel(id: '1', name: 'flowers');
        const metadataModel = MetadataModel(
          currentPage: 1,
          totalPages: 2,
          limit: 10,
        );
        const response = CategoriesResponse(
          categories: [categoryModel],
          metadata: metadataModel,
        );

        when(
          mockDataSource.getCategories(page: 1, limit: 50),
        ).thenAnswer((_) async => SuccessBaseResponse(data: response));

        final result = await repo.getCategories(page: 1, limit: 50);

        expect(result, isA<SuccessBaseResponse<CategoriesResponseEntity>>());
        final success = result as SuccessBaseResponse<CategoriesResponseEntity>;
        expect(success.data.categories.length, 1);
        expect(success.data.categories.first.id, '1');
        expect(success.data.metadata?.currentPage, 1);
        verify(mockDataSource.getCategories(page: 1, limit: 50)).called(1);
      },
    );

    test(
      'returns ErrorBaseResponse<CategoriesResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(
          mockDataSource.getCategories(page: 1, limit: 50),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: exception));

        final result = await repo.getCategories(page: 1, limit: 50);

        expect(result, isA<ErrorBaseResponse<CategoriesResponseEntity>>());
        verify(mockDataSource.getCategories(page: 1, limit: 50)).called(1);
      },
    );
  });

  group('getProductsByCategory', () {
    test(
      'returns SuccessBaseResponse<ProductsResponseEntity> when datasource succeeds',
      () async {
        const productModel = ProductModel(id: '1', title: 'product 1');
        const metadataModel = MetadataModel(
          currentPage: 1,
          totalPages: 2,
          limit: 10,
        );
        const response = ProductsResponse(
          products: [productModel],
          metadata: metadataModel,
        );

        when(
          mockDataSource.getProductsByCategory(
            categoryId: '123',
            sort: null,
            page: 1,
            limit: 10,
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: response));

        final result = await repo.getProductsByCategory(
          categoryId: '123',
          page: 1,
          limit: 10,
        );

        expect(result, isA<SuccessBaseResponse<ProductsResponseEntity>>());
        final success = result as SuccessBaseResponse<ProductsResponseEntity>;
        expect(success.data.products.length, 1);
        expect(success.data.products.first.id, '1');
        verify(
          mockDataSource.getProductsByCategory(
            categoryId: '123',
            sort: null,
            page: 1,
            limit: 10,
          ),
        ).called(1);
      },
    );

    test(
      'returns ErrorBaseResponse<ProductsResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(
          mockDataSource.getProductsByCategory(
            categoryId: '123',
            sort: null,
            page: 1,
            limit: 10,
          ),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: exception));

        final result = await repo.getProductsByCategory(
          categoryId: '123',
          page: 1,
          limit: 10,
        );

        expect(result, isA<ErrorBaseResponse<ProductsResponseEntity>>());
        verify(
          mockDataSource.getProductsByCategory(
            categoryId: '123',
            sort: null,
            page: 1,
            limit: 10,
          ),
        ).called(1);
      },
    );
  });

  group('getAllCategory', () {
    test('returns SuccessBaseResponse with empty data', () async {
      when(mockDataSource.getAllCategory()).thenAnswer(
        (_) async => SuccessBaseResponse<List<CategoryDto>>(data: []),
      );
      final result = await repo.getAllCategory();
      expect(result, isA<SuccessBaseResponse<List<HomeCategoryEntity>>>());
      expect(
        (result as SuccessBaseResponse<List<HomeCategoryEntity>>).data,
        isEmpty,
      );
    });

    test('returns ErrorBaseResponse on exception', () async {
      when(mockDataSource.getAllCategory()).thenAnswer(
        (_) async =>
            ErrorBaseResponse<List<CategoryDto>>(exception: Exception()),
      );
      final result = await repo.getAllCategory();
      expect(result, isA<ErrorBaseResponse<List<HomeCategoryEntity>>>());
    });

    test('returns SuccessBaseResponse with data', () async {
      when(mockDataSource.getAllCategory()).thenAnswer(
        (_) async => SuccessBaseResponse<List<CategoryDto>>(
          data: [
            CategoryDto(
              id: '1',
              name: 'test',
              slug: 'test',
              image: 'test',
              isSuperAdmin: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              productsCount: 1,
            ),
          ],
        ),
      );
      final result = await repo.getAllCategory();
      expect(result, isA<SuccessBaseResponse<List<HomeCategoryEntity>>>());
      expect(
        (result as SuccessBaseResponse<List<HomeCategoryEntity>>).data,
        isNotEmpty,
      );
    });
  });

  group('getAllOccasion', () {
    test('returns SuccessBaseResponse with empty data', () async {
      when(mockDataSource.getAllOccasion()).thenAnswer(
        (_) async => SuccessBaseResponse<List<OccasionDto>>(data: []),
      );
      final result = await repo.getAllOccasion();
      expect(result, isA<SuccessBaseResponse<List<HomeOccasionEntity>>>());
      expect(
        (result as SuccessBaseResponse<List<HomeOccasionEntity>>).data,
        isEmpty,
      );
    });

    test('returns ErrorBaseResponse on exception', () async {
      when(mockDataSource.getAllOccasion()).thenAnswer(
        (_) async =>
            ErrorBaseResponse<List<OccasionDto>>(exception: Exception()),
      );
      final result = await repo.getAllOccasion();
      expect(result, isA<ErrorBaseResponse<List<HomeOccasionEntity>>>());
    });

    test('returns SuccessBaseResponse with data', () async {
      when(mockDataSource.getAllOccasion()).thenAnswer(
        (_) async => SuccessBaseResponse<List<OccasionDto>>(
          data: [
            OccasionDto(
              id: '1',
              name: 'test',
              slug: 'test',
              image: 'test',
              isSuperAdmin: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              productsCount: 1,
            ),
          ],
        ),
      );
      final result = await repo.getAllOccasion();
      expect(result, isA<SuccessBaseResponse<List<HomeOccasionEntity>>>());
      expect(
        (result as SuccessBaseResponse<List<HomeOccasionEntity>>).data,
        isNotEmpty,
      );
    });
  });

  group('getAllBestSeller', () {
    test('returns SuccessBaseResponse with empty data', () async {
      when(mockDataSource.getAllBestSeller()).thenAnswer(
        (_) async => SuccessBaseResponse<List<BestSellerDto>>(data: []),
      );
      final result = await repo.getAllBestSeller();
      expect(result, isA<SuccessBaseResponse<List<BestSellerEntity>>>());
      expect(
        (result as SuccessBaseResponse<List<BestSellerEntity>>).data,
        isEmpty,
      );
    });

    test('returns ErrorBaseResponse on exception', () async {
      when(mockDataSource.getAllBestSeller()).thenAnswer(
        (_) async =>
            ErrorBaseResponse<List<BestSellerDto>>(exception: Exception()),
      );
      final result = await repo.getAllBestSeller();
      expect(result, isA<ErrorBaseResponse<List<BestSellerEntity>>>());
    });

    test('returns SuccessBaseResponse with data', () async {
      when(mockDataSource.getAllBestSeller()).thenAnswer(
        (_) async => SuccessBaseResponse<List<BestSellerDto>>(
          data: [
            BestSellerDto(
              id: '1',
              slug: 'test',
              isSuperAdmin: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ],
        ),
      );
      final result = await repo.getAllBestSeller();
      expect(result, isA<SuccessBaseResponse<List<BestSellerEntity>>>());
      expect(
        (result as SuccessBaseResponse<List<BestSellerEntity>>).data,
        isNotEmpty,
      );
    });
  });

  group('getOccasions', () {
    test(
      'returns SuccessBaseResponse<OccasionsEntity> when datasource succeeds',
      () async {
        final response = occasions_model.OccasionsResponse(
          message: 'success',
          metadata: occasions_model.Metadata(
            currentPage: 1,
            totalPages: 2,
            limit: 10,
            totalItems: 15,
          ),
          occasions: [
            occasions_model.Occasion(
              id: '1',
              name: 'Wedding',
              productsCount: 13,
            ),
          ],
        );

        when(mockDataSource.getOccasions(page: 1, limit: 10)).thenAnswer((
          _,
        ) async {
          return SuccessBaseResponse<occasions_model.OccasionsResponse>(
            data: response,
          );
        });

        final result = await repo.getOccasions(page: 1, limit: 10);

        expect(result, isA<SuccessBaseResponse<OccasionsEntity>>());
        final data = (result as SuccessBaseResponse<OccasionsEntity>).data;
        expect(data.currentPage, 1);
        expect(data.totalPages, 2);
        expect(data.occasions, [
          const OccasionEntity(id: '1', name: 'Wedding', productsCount: 13),
        ]);
        verify(mockDataSource.getOccasions(page: 1, limit: 10)).called(1);
      },
    );

    test('returns ErrorBaseResponse when datasource fails', () async {
      final exception = Exception('Server Error');

      when(mockDataSource.getOccasions(page: 1, limit: 10)).thenAnswer((
        _,
      ) async {
        return ErrorBaseResponse<occasions_model.OccasionsResponse>(
          exception: exception,
        );
      });

      final result = await repo.getOccasions(page: 1, limit: 10);

      expect(result, isA<ErrorBaseResponse<OccasionsEntity>>());
      expect(
        (result as ErrorBaseResponse<OccasionsEntity>).exception,
        exception,
      );
    });
  });

  group('getProductsByOccasion', () {
    test(
      'returns SuccessBaseResponse<ProductsEntity> when datasource succeeds',
      () async {
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
          mockDataSource.getProductsByOccasion(
            occasionId: 'occasion_1',
            page: 1,
            limit: 10,
          ),
        ).thenAnswer((_) async {
          return SuccessBaseResponse<products_model.OccasionProductsResponse>(
            data: response,
          );
        });

        final result = await repo.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        );

        expect(result, isA<SuccessBaseResponse<ProductsEntity>>());
        final data = (result as SuccessBaseResponse<ProductsEntity>).data;
        expect(data.currentPage, 1);
        expect(data.totalPages, 3);
        expect(data.products, [
          const occasion_entities.ProductEntity(
            id: '1',
            name: 'Wedding Flower',
            imageUrl: 'image.png',
            price: 100,
            originalPrice: 300,
            discountPercent: 60,
          ),
        ]);
        verify(
          mockDataSource.getProductsByOccasion(
            occasionId: 'occasion_1',
            page: 1,
            limit: 10,
          ),
        ).called(1);
      },
    );

    test('returns ErrorBaseResponse when datasource fails', () async {
      final exception = Exception('Server Error');

      when(
        mockDataSource.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).thenAnswer((_) async {
        return ErrorBaseResponse<products_model.OccasionProductsResponse>(
          exception: exception,
        );
      });

      final result = await repo.getProductsByOccasion(
        occasionId: 'occasion_1',
        page: 1,
        limit: 10,
      );

      expect(result, isA<ErrorBaseResponse<ProductsEntity>>());
      expect(
        (result as ErrorBaseResponse<ProductsEntity>).exception,
        exception,
      );
    });
  });

  group('searchProducts', () {
    test(
      'returns SuccessBaseResponse<ProductsResponseEntity> when datasource succeeds',
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

        final result = await repo.searchProducts(query: 'rose');

        expect(result, isA<SuccessBaseResponse<ProductsResponseEntity>>());
        final success = result as SuccessBaseResponse<ProductsResponseEntity>;
        expect(success.data.products.length, 1);
        expect(success.data.products.first.id, '1');
        verify(mockDataSource.searchProducts(query: 'rose')).called(1);
      },
    );

    test(
      'returns ErrorBaseResponse<ProductsResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');

        when(
          mockDataSource.searchProducts(query: 'rose'),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: exception));

        final result = await repo.searchProducts(query: 'rose');

        expect(result, isA<ErrorBaseResponse<ProductsResponseEntity>>());
        verify(mockDataSource.searchProducts(query: 'rose')).called(1);
      },
    );
  });
}

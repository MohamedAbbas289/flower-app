import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/occasions/data/datasources_contract/occasions_remote_datasource_contract.dart';
import 'package:flower_app/features/occasions/data/models/occasions_response.dart'
    as occasions_model;
import 'package:flower_app/features/occasions/data/models/products_response.dart'
    as products_model;
import 'package:flower_app/features/occasions/data/repositories_impl/occasions_repository_impl.dart';
import 'package:flower_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/occasions/domain/entities/products_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occasions_repository_impl_test.mocks.dart';

@GenerateMocks([OccasionsRemoteDatasourceContract])
void main() {
  provideDummy<BaseResponse<occasions_model.OccasionsResponse>>(
    SuccessBaseResponse<occasions_model.OccasionsResponse>(
      data: occasions_model.OccasionsResponse(),
    ),
  );

  provideDummy<BaseResponse<products_model.ProductsResponse>>(
    SuccessBaseResponse<products_model.ProductsResponse>(
      data: products_model.ProductsResponse(),
    ),
  );

  late MockOccasionsRemoteDatasourceContract mockDatasource;
  late OccasionsRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockOccasionsRemoteDatasourceContract();
    repository = OccasionsRepositoryImpl(mockDatasource);
  });

  group('getOccasions', () {
    test(
      'should return SuccessBaseResponse<OccasionsEntity> when datasource succeeds',
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

        when(mockDatasource.getOccasions(page: 1, limit: 10)).thenAnswer((
          _,
        ) async {
          return SuccessBaseResponse<occasions_model.OccasionsResponse>(
            data: response,
          );
        });

        final result = await repository.getOccasions(page: 1, limit: 10);

        expect(result, isA<SuccessBaseResponse<OccasionsEntity>>());

        final data = (result as SuccessBaseResponse<OccasionsEntity>).data;

        expect(data.currentPage, 1);

        expect(data.totalPages, 2);

        expect(data.occasions, [
          const OccasionEntity(id: '1', name: 'Wedding', productsCount: 13),
        ]);

        verify(mockDatasource.getOccasions(page: 1, limit: 10)).called(1);

        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test('should return ErrorBaseResponse when datasource fails', () async {
      final exception = Exception('Server Error');

      when(mockDatasource.getOccasions(page: 1, limit: 10)).thenAnswer((
        _,
      ) async {
        return ErrorBaseResponse<occasions_model.OccasionsResponse>(
          exception: exception,
        );
      });

      final result = await repository.getOccasions(page: 1, limit: 10);

      expect(result, isA<ErrorBaseResponse<OccasionsEntity>>());

      expect(
        (result as ErrorBaseResponse<OccasionsEntity>).exception,
        exception,
      );
    });
  });

  group('getProductsByOccasion', () {
    test(
      'should return SuccessBaseResponse<ProductsEntity> when datasource succeeds',
      () async {
        final response = products_model.ProductsResponse(
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
          mockDatasource.getProductsByOccasion(
            occasionId: 'occasion_1',
            page: 1,
            limit: 10,
          ),
        ).thenAnswer((_) async {
          return SuccessBaseResponse<products_model.ProductsResponse>(
            data: response,
          );
        });

        final result = await repository.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        );

        expect(result, isA<SuccessBaseResponse<ProductsEntity>>());

        final data = (result as SuccessBaseResponse<ProductsEntity>).data;

        expect(data.currentPage, 1);

        expect(data.totalPages, 3);

        expect(data.products, [
          const ProductEntity(
            id: '1',
            name: 'Wedding Flower',
            imageUrl: 'image.png',
            price: 100,
            originalPrice: 300,
            discountPercent: 60,
          ),
        ]);

        verify(
          mockDatasource.getProductsByOccasion(
            occasionId: 'occasion_1',
            page: 1,
            limit: 10,
          ),
        ).called(1);

        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test('should return ErrorBaseResponse when datasource fails', () async {
      final exception = Exception('Server Error');

      when(
        mockDatasource.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).thenAnswer((_) async {
        return ErrorBaseResponse<products_model.ProductsResponse>(
          exception: exception,
        );
      });

      final result = await repository.getProductsByOccasion(
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
}

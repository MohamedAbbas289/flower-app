import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/request_models/get_products_by_category_request_model.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:flower_app/features/categories/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_products_by_category_use_case_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  late MockCategoriesRepository mockCategoriesRepository;
  late GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse<List<ProductEntity>>(data: []),
    );
  });

  setUp(() {
    mockCategoriesRepository = MockCategoriesRepository();
    getProductsByCategoryUseCase = GetProductsByCategoryUseCase(
      mockCategoriesRepository,
    );
  });

  group('GetProductsByCategoryUseCase', () {
    const request = GetProductsByCategoryRequestModel(categoryId: "123");

    test(
      'should return SuccessBaseResponse<List<ProductEntity>> when repository succeeds',
      () async {
        final successResponse = SuccessBaseResponse<List<ProductEntity>>(
          data: const [ProductEntity(id: "1")],
        );

        when(
          mockCategoriesRepository.getProductsByCategory(categoryId: "123"),
        ).thenAnswer((_) async => successResponse);

        final result = await getProductsByCategoryUseCase.execute(
          requestModel: request,
        );

        expect(result, isA<SuccessBaseResponse<List<ProductEntity>>>());
        final success = result as SuccessBaseResponse<List<ProductEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, "1");
        verify(
          mockCategoriesRepository.getProductsByCategory(categoryId: "123"),
        ).called(1);
        verifyNoMoreInteractions(mockCategoriesRepository);
      },
    );

    test(
      'should return ErrorBaseResponse<List<ProductEntity>> when repository fails',
      () async {
        final exception = Exception("network error");
        final errorResponse = ErrorBaseResponse<List<ProductEntity>>(
          exception: exception,
        );

        when(
          mockCategoriesRepository.getProductsByCategory(categoryId: "123"),
        ).thenAnswer((_) async => errorResponse);

        final result = await getProductsByCategoryUseCase.execute(
          requestModel: request,
        );

        expect(result, isA<ErrorBaseResponse<List<ProductEntity>>>());
        final error = result as ErrorBaseResponse<List<ProductEntity>>;
        expect(error.exception, exception);
        verify(
          mockCategoriesRepository.getProductsByCategory(categoryId: "123"),
        ).called(1);
        verifyNoMoreInteractions(mockCategoriesRepository);
      },
    );
  });
}

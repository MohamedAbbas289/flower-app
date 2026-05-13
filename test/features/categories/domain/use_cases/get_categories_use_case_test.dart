import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:flower_app/features/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_categories_use_case_test.mocks.dart';

@GenerateMocks([CategoriesRepository])
void main() {
  late MockCategoriesRepository mockCategoriesRepository;
  late GetCategoriesUseCase getCategoriesUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<CategoriesResponseEntity>>(
      SuccessBaseResponse<CategoriesResponseEntity>(
        data: const CategoriesResponseEntity(categories: []),
      ),
    );
  });

  setUp(() {
    mockCategoriesRepository = MockCategoriesRepository();
    getCategoriesUseCase = GetCategoriesUseCase(mockCategoriesRepository);
  });

  group('GetCategoriesUseCase', () {
    test(
      'should return SuccessBaseResponse<CategoriesResponseEntity> when repository succeeds',
      () async {
        final successResponse = SuccessBaseResponse<CategoriesResponseEntity>(
          data: const CategoriesResponseEntity(
              categories: [CategoryEntity(id: "1")]),
        );

        when(mockCategoriesRepository.getCategories(page: 1, limit: 10))
            .thenAnswer((_) async => successResponse);

        final result = await getCategoriesUseCase.execute(page: 1, limit: 10);

        expect(result, isA<SuccessBaseResponse<CategoriesResponseEntity>>());
        final success = result as SuccessBaseResponse<CategoriesResponseEntity>;
        expect(success.data.categories.length, 1);
        expect(success.data.categories.first.id, "1");
        verify(mockCategoriesRepository.getCategories(page: 1, limit: 10))
            .called(1);
        verifyNoMoreInteractions(mockCategoriesRepository);
      },
    );

    test(
      'should return ErrorBaseResponse<CategoriesResponseEntity> when repository fails',
      () async {
        final exception = Exception("network error");
        final errorResponse = ErrorBaseResponse<CategoriesResponseEntity>(
          exception: exception,
        );

        when(mockCategoriesRepository.getCategories(page: null, limit: null))
            .thenAnswer((_) async => errorResponse);

        final result = await getCategoriesUseCase.execute();

        expect(result, isA<ErrorBaseResponse<CategoriesResponseEntity>>());
        final error = result as ErrorBaseResponse<CategoriesResponseEntity>;
        expect(error.exception, exception);
        verify(mockCategoriesRepository.getCategories(page: null, limit: null))
            .called(1);
        verifyNoMoreInteractions(mockCategoriesRepository);
      },
    );
  });
}

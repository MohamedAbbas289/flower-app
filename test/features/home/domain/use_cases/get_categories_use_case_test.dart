import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/home/domain/entities/category_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:flower_app/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'get_categories_use_case_test.mocks.dart';

@GenerateMocks([HomeRepositoryContract])
void main() {
  late MockHomeRepositoryContract mockRepository;
  late GetCategoriesUseCase getCategoriesUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<CategoriesResponseEntity>>(
      SuccessBaseResponse<CategoriesResponseEntity>(
        data: const CategoriesResponseEntity(categories: []),
      ),
    );
  });

  setUp(() {
    mockRepository = MockHomeRepositoryContract();
    getCategoriesUseCase = GetCategoriesUseCase(mockRepository);
  });

  group('GetCategoriesUseCase', () {
    test(
      'execute returns SuccessBaseResponse<CategoriesResponseEntity> when repository succeeds',
      () async {
        final successResponse = SuccessBaseResponse<CategoriesResponseEntity>(
          data: const CategoriesResponseEntity(
              categories: [CategoryEntity(id: '1')]),
        );

        when(mockRepository.getCategories(page: 1, limit: 50))
            .thenAnswer((_) async => successResponse);

        final result = await getCategoriesUseCase.execute(page: 1, limit: 50);

        expect(result, isA<SuccessBaseResponse<CategoriesResponseEntity>>());
        final success = result as SuccessBaseResponse<CategoriesResponseEntity>;
        expect(success.data.categories.length, 1);
        expect(success.data.categories.first.id, '1');
        verify(mockRepository.getCategories(page: 1, limit: 50)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'execute returns ErrorBaseResponse<CategoriesResponseEntity> when repository fails',
      () async {
        final exception = Exception('network error');
        final errorResponse = ErrorBaseResponse<CategoriesResponseEntity>(
          exception: exception,
        );

        when(mockRepository.getCategories(page: 1, limit: 50))
            .thenAnswer((_) async => errorResponse);

        final result = await getCategoriesUseCase.execute(page: 1, limit: 50);

        expect(result, isA<ErrorBaseResponse<CategoriesResponseEntity>>());
        final error = result as ErrorBaseResponse<CategoriesResponseEntity>;
        expect(error.exception, exception);
        verify(mockRepository.getCategories(page: 1, limit: 50)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}

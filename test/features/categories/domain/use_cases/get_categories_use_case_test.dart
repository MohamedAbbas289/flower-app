import 'package:flower_app/config/base_response/base_response.dart';
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
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>(data: []),
    );
  });

  setUp(() {
    mockCategoriesRepository = MockCategoriesRepository();
    getCategoriesUseCase = GetCategoriesUseCase(mockCategoriesRepository);
  });

  group('GetCategoriesUseCase', () {
    test(
      'should return SuccessBaseResponse<List<CategoryEntity>> when repository succeeds',
      () async {
        final successResponse = SuccessBaseResponse<List<CategoryEntity>>(
          data: const [CategoryEntity(id: "1")],
        );

        when(
          mockCategoriesRepository.getCategories(),
        ).thenAnswer((_) async => successResponse);

        final result = await getCategoriesUseCase.execute();

        expect(result, isA<SuccessBaseResponse<List<CategoryEntity>>>());
        final success = result as SuccessBaseResponse<List<CategoryEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, "1");
        verify(mockCategoriesRepository.getCategories()).called(1);
        verifyNoMoreInteractions(mockCategoriesRepository);
      },
    );

    test(
      'should return ErrorBaseResponse<List<CategoryEntity>> when repository fails',
      () async {
        final exception = Exception("network error");
        final errorResponse = ErrorBaseResponse<List<CategoryEntity>>(
          exception: exception,
        );

        when(
          mockCategoriesRepository.getCategories(),
        ).thenAnswer((_) async => errorResponse);

        final result = await getCategoriesUseCase.execute();

        expect(result, isA<ErrorBaseResponse<List<CategoryEntity>>>());
        final error = result as ErrorBaseResponse<List<CategoryEntity>>;
        expect(error.exception, exception);
        verify(mockCategoriesRepository.getCategories()).called(1);
        verifyNoMoreInteractions(mockCategoriesRepository);
      },
    );
  });
}

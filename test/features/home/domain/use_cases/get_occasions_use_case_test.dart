import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:flower_app/features/home/domain/use_cases/get_occasions_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_occasions_use_case_test.mocks.dart';

@GenerateMocks([HomeRepositoryContract])
void main() {
  provideDummy<BaseResponse<OccasionsEntity>>(
    SuccessBaseResponse<OccasionsEntity>(
      data: const OccasionsEntity(occasions: [], totalPages: 1, currentPage: 1),
    ),
  );

  late MockHomeRepositoryContract mockRepository;
  late GetOccasionsUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepositoryContract();
    useCase = GetOccasionsUseCase(mockRepository);
  });

  test(
    'should return SuccessBaseResponse<OccasionsEntity> when repository succeeds',
    () async {
      final response = SuccessBaseResponse<OccasionsEntity>(
        data: const OccasionsEntity(
          occasions: [
            OccasionEntity(id: '1', name: 'Wedding', productsCount: 13),
          ],
          totalPages: 2,
          currentPage: 1,
        ),
      );

      when(mockRepository.getOccasions(page: 1, limit: 10)).thenAnswer((
        _,
      ) async {
        return response;
      });

      final result = await useCase.execute(page: 1, limit: 10);

      expect(result, response);

      verify(mockRepository.getOccasions(page: 1, limit: 10)).called(1);

      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return ErrorBaseResponse when repository fails', () async {
    final response = ErrorBaseResponse<OccasionsEntity>(
      exception: Exception('Server Error'),
    );

    when(mockRepository.getOccasions(page: 1, limit: 10)).thenAnswer((_) async {
      return response;
    });

    final result = await useCase.execute(page: 1, limit: 10);

    expect(result, response);

    verify(mockRepository.getOccasions(page: 1, limit: 10)).called(1);

    verifyNoMoreInteractions(mockRepository);
  });
}

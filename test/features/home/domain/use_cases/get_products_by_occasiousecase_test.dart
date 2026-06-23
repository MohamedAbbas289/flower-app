import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/products_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:flower_app/features/home/domain/use_cases/get_products_by_occasiousecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_products_by_occasiousecase_test.mocks.dart';

@GenerateMocks([HomeRepositoryContract])
void main() {
  provideDummy<BaseResponse<ProductsEntity>>(
    SuccessBaseResponse<ProductsEntity>(
      data: const ProductsEntity(products: [], totalPages: 1, currentPage: 1),
    ),
  );

  late MockHomeRepositoryContract mockRepository;
  late GetProductsByOccasionUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepositoryContract();
    useCase = GetProductsByOccasionUseCase(mockRepository);
  });

  test(
    'should return SuccessBaseResponse<ProductsEntity> when repository succeeds',
    () async {
      final response = SuccessBaseResponse<ProductsEntity>(
        data: const ProductsEntity(
          products: [
            ProductEntity(
              id: '1',
              name: 'Wedding Flower',
              imageUrl: 'image.png',
              price: 100,
              originalPrice: 300,
              discountPercent: 60,
            ),
          ],
          totalPages: 3,
          currentPage: 1,
        ),
      );

      when(
        mockRepository.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).thenAnswer((_) async {
        return response;
      });

      final result = await useCase.execute(
        occasionId: 'occasion_1',
        page: 1,
        limit: 10,
      );

      expect(result, response);

      verify(
        mockRepository.getProductsByOccasion(
          occasionId: 'occasion_1',
          page: 1,
          limit: 10,
        ),
      ).called(1);

      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return ErrorBaseResponse when repository fails', () async {
    final response = ErrorBaseResponse<ProductsEntity>(
      exception: Exception('Server Error'),
    );

    when(
      mockRepository.getProductsByOccasion(
        occasionId: 'occasion_1',
        page: 1,
        limit: 10,
      ),
    ).thenAnswer((_) async {
      return response;
    });

    final result = await useCase.execute(
      occasionId: 'occasion_1',
      page: 1,
      limit: 10,
    );

    expect(result, response);

    verify(
      mockRepository.getProductsByOccasion(
        occasionId: 'occasion_1',
        page: 1,
        limit: 10,
      ),
    ).called(1);

    verifyNoMoreInteractions(mockRepository);
  });
}

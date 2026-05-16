import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_best_seller_use_case.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_category_use_cases.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_occasion_use_case.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/states/home_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([
  GetCategoryUseCases,
  GetOccasionUseCase,
  GetBestSellerUseCase,
])
void main() {
  late MockGetCategoryUseCases mockGetCategoryUseCases;
  late MockGetOccasionUseCase mockGetOccasionUseCase;
  late MockGetBestSellerUseCase mockGetBestSellerUseCase;

  late HomeViewEntity viewEntity;

  setUp(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>(data: []),
    );
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      ErrorBaseResponse<List<CategoryEntity>>(exception: Exception()),
    );
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>(data: [
        CategoryEntity(
          id: '1',
          name: 'test',
          slug: 'test',
          image: 'test',
          isSuperAdmin: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productsCount: 1,
        ),],
      ),);
    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessBaseResponse<List<OccasionEntity>>(data: []),
    );
    provideDummy<BaseResponse<List<OccasionEntity>>>(
      ErrorBaseResponse<List<OccasionEntity>>(exception: Exception()),
    );
    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessBaseResponse<List<OccasionEntity>>(data: [
        OccasionEntity(
          id: '1',
          name: 'test',
          slug: 'test',
          image: 'test',
          isSuperAdmin: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          productsCount: 1,
        ),
      ]),
    );
    provideDummy<BaseResponse<List<BestSellerEntity>>>(
      SuccessBaseResponse<List<BestSellerEntity>>(data: []),
    );
    provideDummy<BaseResponse<List<BestSellerEntity>>>(
      ErrorBaseResponse<List<BestSellerEntity>>(exception: Exception()),
    );
    provideDummy<BaseResponse<List<BestSellerEntity>>>(
      SuccessBaseResponse<List<BestSellerEntity>>(data: [
        BestSellerEntity(
          id: '1',
          slug: 'test',
          isSuperAdmin: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ]),
    );




    mockGetCategoryUseCases = MockGetCategoryUseCases();
    mockGetOccasionUseCase = MockGetOccasionUseCase();
    mockGetBestSellerUseCase = MockGetBestSellerUseCase();

    viewEntity = HomeViewEntity(
      mockGetCategoryUseCases,
      mockGetOccasionUseCase,
      mockGetBestSellerUseCase,
    );
  });

  group('HomeViewEntity Tests', () {

    test(' Test Success Case initial state in HomeState With Empty Data  ', () async {

      when(mockGetCategoryUseCases()).thenAnswer(
            (_) async => SuccessBaseResponse<List<CategoryEntity>>(
          data: [],
        ),
      );

      when(mockGetOccasionUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<OccasionEntity>>(
          data: [],
        ),
      );

      when(mockGetBestSellerUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<BestSellerEntity>>(
          data: [],
        ),
      );

      await viewEntity.doEvent(GetAllDataEvent());
      expect(viewEntity.state.categories, []);
      expect(viewEntity.state.occasions, []);
      expect(viewEntity.state.bestSellers, []);



    });
    test(' Test Error Case initial state in HomeState With Exception    ', () async {

      when(mockGetCategoryUseCases()).thenAnswer(
            (_) async => ErrorBaseResponse<List<CategoryEntity>>(
          exception: Exception(),
        ),
      );
      when(mockGetOccasionUseCase()).thenAnswer(
            (_) async => ErrorBaseResponse<List<OccasionEntity>>(
          exception: Exception(),
        ),
      );
      when(mockGetBestSellerUseCase()).thenAnswer(
            (_) async => ErrorBaseResponse<List<BestSellerEntity>>(
          exception: Exception(),
        ),
      );

      await viewEntity.doEvent(GetAllDataEvent());
      expect(viewEntity.state.categoriesError, isNotEmpty);
      expect(viewEntity.state.occasionsError, isNotEmpty);
      expect(viewEntity.state.bestSellersError, isNotEmpty);



    });
    test(' Test Success Case initial state in HomeState With  Data  ', () async {

      when(mockGetCategoryUseCases()).thenAnswer(
            (_) async => SuccessBaseResponse<List<CategoryEntity>>(
          data: [
            CategoryEntity(
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

      when(mockGetOccasionUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<OccasionEntity>>(
          data: [
            OccasionEntity(
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

      when(mockGetBestSellerUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<BestSellerEntity>>(
          data: [
            BestSellerEntity(
              id: '1',
              slug: 'test',
              isSuperAdmin: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ],
        ),
      );

      await viewEntity.doEvent(GetAllDataEvent());
      expect(viewEntity.state.categories, isNotEmpty);
      expect(viewEntity.state.occasions, isNotEmpty);
      expect(viewEntity.state.bestSellers, isNotEmpty);



    });

  });
}
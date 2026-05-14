import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home_screen/domain/entities/best_seller_model.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_model.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_model.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_best_seller_use_case.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_category_use_cases.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_occasion_use_case.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/cubit/home_view_model.dart';
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

  late HomeViewModel viewModel;

  setUp(() {
    provideDummy<BaseResponse<List<CategoryModel>>>(
      SuccessBaseResponse<List<CategoryModel>>(data: []),
    );
    provideDummy<BaseResponse<List<CategoryModel>>>(
      ErrorBaseResponse<List<CategoryModel>>(exception: Exception()),
    );
    provideDummy<BaseResponse<List<CategoryModel>>>(
      SuccessBaseResponse<List<CategoryModel>>(data: [
        CategoryModel(
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
    provideDummy<BaseResponse<List<OccasionModel>>>(
      SuccessBaseResponse<List<OccasionModel>>(data: []),
    );
    provideDummy<BaseResponse<List<OccasionModel>>>(
      ErrorBaseResponse<List<OccasionModel>>(exception: Exception()),
    );
    provideDummy<BaseResponse<List<OccasionModel>>>(
      SuccessBaseResponse<List<OccasionModel>>(data: [
        OccasionModel(
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
    provideDummy<BaseResponse<List<BestSellerModel>>>(
      SuccessBaseResponse<List<BestSellerModel>>(data: []),
    );
    provideDummy<BaseResponse<List<BestSellerModel>>>(
      ErrorBaseResponse<List<BestSellerModel>>(exception: Exception()),
    );
    provideDummy<BaseResponse<List<BestSellerModel>>>(
      SuccessBaseResponse<List<BestSellerModel>>(data: [
        BestSellerModel(
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

    viewModel = HomeViewModel(
      mockGetCategoryUseCases,
      mockGetOccasionUseCase,
      mockGetBestSellerUseCase,
    );
  });

  group('HomeViewModel Tests', () {

    test(' Test Success Case initial state in HomeState With Empty Data  ', () async {

      when(mockGetCategoryUseCases()).thenAnswer(
            (_) async => SuccessBaseResponse<List<CategoryModel>>(
          data: [],
        ),
      );

      when(mockGetOccasionUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<OccasionModel>>(
          data: [],
        ),
      );

      when(mockGetBestSellerUseCase()).thenAnswer(
            (_) async => SuccessBaseResponse<List<BestSellerModel>>(
          data: [],
        ),
      );

      await viewModel.doEvent(GetAllDataEvent());
      expect(viewModel.state.categories, []);
      expect(viewModel.state.occasions, []);
      expect(viewModel.state.bestSellers, []);



    });
    test(' Test Error Case initial state in HomeState With Exception    ', () async {

      when(mockGetCategoryUseCases()).thenAnswer(
            (_) async => ErrorBaseResponse<List<CategoryModel>>(
          exception: Exception(),
        ),
      );
      when(mockGetOccasionUseCase()).thenAnswer(
            (_) async => ErrorBaseResponse<List<OccasionModel>>(
          exception: Exception(),
        ),
      );
      when(mockGetBestSellerUseCase()).thenAnswer(
            (_) async => ErrorBaseResponse<List<BestSellerModel>>(
          exception: Exception(),
        ),
      );

      await viewModel.doEvent(GetAllDataEvent());
      expect(viewModel.state.categoriesError, isNotEmpty);
      expect(viewModel.state.occasionsError, isNotEmpty);
      expect(viewModel.state.bestSellersError, isNotEmpty);



    });
    test(' Test Success Case initial state in HomeState With  Data  ', () async {

      when(mockGetCategoryUseCases()).thenAnswer(
            (_) async => SuccessBaseResponse<List<CategoryModel>>(
          data: [
            CategoryModel(
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
            (_) async => SuccessBaseResponse<List<OccasionModel>>(
          data: [
            OccasionModel(
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
            (_) async => SuccessBaseResponse<List<BestSellerModel>>(
          data: [
            BestSellerModel(
              id: '1',
              slug: 'test',
              isSuperAdmin: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ],
        ),
      );

      await viewModel.doEvent(GetAllDataEvent());
      expect(viewModel.state.categories, isNotEmpty);
      expect(viewModel.state.occasions, isNotEmpty);
      expect(viewModel.state.bestSellers, isNotEmpty);



    });

  });
}
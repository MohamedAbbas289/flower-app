import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_best_seller_use_case.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_category_use_cases.dart';
import 'package:flower_app/features/home_screen/domain/use_cases/get_occasion_use_case.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/cubit/home_view_model.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/states/home_events.dart';
import 'package:flower_app/features/home_screen/presentation/view_model/states/home_state.dart';
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

  final tCategory = CategoryEntity(
    id: '1',
    name: 'test',
    image: 'test',
    productsCount: 1,
  );

  final tOccasion = OccasionEntity(
    id: '1',
    name: 'test',
    image: 'test',
    productsCount: 1,
  );

  final tBestSeller = BestSellerEntity(
    id: '1',
  );

  final tErrorMessage = 'Something went wrong';

  HomeViewModel buildViewModel() => HomeViewModel(
        mockGetCategoryUseCases,
        mockGetBestSellerUseCase,
        mockGetOccasionUseCase,
      );


  setUp(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>(data: []),
    );
    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessBaseResponse<List<OccasionEntity>>(data: []),
    );
    provideDummy<BaseResponse<List<BestSellerEntity>>>(
      SuccessBaseResponse<List<BestSellerEntity>>(data: []),
    );

    mockGetCategoryUseCases = MockGetCategoryUseCases();
    mockGetOccasionUseCase = MockGetOccasionUseCase();
    mockGetBestSellerUseCase = MockGetBestSellerUseCase();
  });


  void stubAllSuccess({
    List<CategoryEntity> categories = const [],
    List<OccasionEntity> occasions = const [],
    List<BestSellerEntity> bestSellers = const [],
  }) {
    when(mockGetCategoryUseCases())
        .thenAnswer((_) async => SuccessBaseResponse(data: categories));
    when(mockGetOccasionUseCase())
        .thenAnswer((_) async => SuccessBaseResponse(data: occasions));
    when(mockGetBestSellerUseCase())
        .thenAnswer((_) async => SuccessBaseResponse(data: bestSellers));
  }

  void stubAllError() {
    when(mockGetCategoryUseCases()).thenAnswer(
      (_) async => ErrorBaseResponse<List<CategoryEntity>>(
        exception: Exception(tErrorMessage),
      ),
    );
    when(mockGetOccasionUseCase()).thenAnswer(
      (_) async => ErrorBaseResponse<List<OccasionEntity>>(
        exception: Exception(tErrorMessage),
      ),
    );
    when(mockGetBestSellerUseCase()).thenAnswer(
      (_) async => ErrorBaseResponse<List<BestSellerEntity>>(
        exception: Exception(tErrorMessage),
      ),
    );
  }


  group('HomeViewModel – initial state', () {
    test('state is HomeState() with all BaseState default (idle)', () {
      final vm = buildViewModel();
      expect(vm.state, const HomeState());
      vm.close();
    });
  });

  group('HomeViewModel – LoadHomeDataEvent', () {
    blocTest<HomeViewModel, HomeState>(
      'emits loading then success states when all use-cases return empty lists',
      build: () {
        stubAllSuccess();
        return buildViewModel();
      },
      act: (vm) => vm.doEvent(const LoadHomeDataEvent()),

      verify: (vm) {
        expect(vm.state.categoriesState.data, isEmpty);
        expect(vm.state.occasionsState.data, isEmpty);
        expect(vm.state.bestSellersState.data, isEmpty);
        expect(vm.state.categoriesState.msg, isNull);
        expect(vm.state.occasionsState.msg, isNull);
        expect(vm.state.bestSellersState.msg, isNull);
      },
    );

    blocTest<HomeViewModel, HomeState>(
      'emits loading then success states when all use-cases return non-empty data',
      build: () {
        stubAllSuccess(
          categories: [tCategory],
          occasions: [tOccasion],
          bestSellers: [tBestSeller],
        );
        return buildViewModel();
      },
      act: (vm) => vm.doEvent(const LoadHomeDataEvent()),
      verify: (vm) {
        expect(vm.state.categoriesState.data, [tCategory]);
        expect(vm.state.occasionsState.data, [tOccasion]);
        expect(vm.state.bestSellersState.data, [tBestSeller]);
        expect(vm.state.categoriesState.msg, isNull);
        expect(vm.state.occasionsState.msg, isNull);
        expect(vm.state.bestSellersState.msg, isNull);
      },
    );

    blocTest<HomeViewModel, HomeState>(
      'emits loading then error states when all use-cases throw',
      build: () {
        stubAllError();
        return buildViewModel();
      },
      act: (vm) => vm.doEvent(const LoadHomeDataEvent()),
      verify: (vm) {
        expect(vm.state.categoriesState.msg, isNotNull);
        expect(vm.state.occasionsState.msg, isNotNull);
        expect(vm.state.bestSellersState.msg, isNotNull);
        expect(vm.state.categoriesState.data, isNull);
        expect(vm.state.occasionsState.data, isNull);
        expect(vm.state.bestSellersState.data, isNull);
      },
    );
  });

  group('HomeViewModel – RetryLoadHomeDataEvent', () {
    blocTest<HomeViewModel, HomeState>(
      'retries only failed sections and keeps successful ones intact',
      build: () {
        when(mockGetCategoryUseCases()).thenAnswer(
          (_) async => ErrorBaseResponse<List<CategoryEntity>>(
            exception: Exception(tErrorMessage),
          ),
        );
        when(mockGetOccasionUseCase())
            .thenAnswer((_) async => SuccessBaseResponse(data: [tOccasion]));
        when(mockGetBestSellerUseCase())
            .thenAnswer((_) async => SuccessBaseResponse(data: [tBestSeller]));

        return buildViewModel();
      },
      act: (vm) async {
        vm.doEvent(const LoadHomeDataEvent());
        await Future<void>.delayed(const Duration(milliseconds: 50));

        when(mockGetCategoryUseCases())
            .thenAnswer((_) async => SuccessBaseResponse(data: [tCategory]));

        vm.doEvent(const RetryLoadHomeDataEvent());
        await Future<void>.delayed(const Duration(milliseconds: 50));
      },
      verify: (vm) {
        expect(vm.state.categoriesState.data, [tCategory]);
        expect(vm.state.categoriesState.msg, isNull);

        expect(vm.state.occasionsState.data, [tOccasion]);
        expect(vm.state.bestSellersState.data, [tBestSeller]);
      },
    );

    blocTest<HomeViewModel, HomeState>(
      'does nothing when all sections are already successful',
      build: () {
        stubAllSuccess(
          categories: [tCategory],
          occasions: [tOccasion],
          bestSellers: [tBestSeller],
        );
        return buildViewModel();
      },
      act: (vm) async {
        vm.doEvent(const LoadHomeDataEvent());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        vm.doEvent(const RetryLoadHomeDataEvent());
        await Future<void>.delayed(const Duration(milliseconds: 50));
      },
      verify: (vm) {
        verify(mockGetCategoryUseCases()).called(1);
        verify(mockGetOccasionUseCase()).called(1);
        verify(mockGetBestSellerUseCase()).called(1);
      },
    );
  });
}
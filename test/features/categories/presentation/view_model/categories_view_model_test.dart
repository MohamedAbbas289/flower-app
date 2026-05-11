import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:flower_app/features/categories/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_events.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_states.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'categories_view_model_test.mocks.dart';

@GenerateMocks([GetCategoriesUseCase, GetProductsByCategoryUseCase])
void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsByCategoryUseCase mockGetProductsByCategoryUseCase;
  late CategoriesViewModel viewModel;

  setUpAll(() {
    provideDummy<BaseResponse<List<CategoryEntity>>>(
      SuccessBaseResponse<List<CategoryEntity>>(data: []),
    );
    provideDummy<BaseResponse<List<ProductEntity>>>(
      SuccessBaseResponse<List<ProductEntity>>(data: []),
    );
  });

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetProductsByCategoryUseCase = MockGetProductsByCategoryUseCase();
    viewModel = CategoriesViewModel(
      mockGetCategoriesUseCase,
      mockGetProductsByCategoryUseCase,
    );
  });

  group('CategoriesViewModel', () {
    test('initial state should be const CategoriesInitial()', () {
      expect(viewModel.state, equals(const CategoriesInitial()));
    });

    blocTest<CategoriesViewModel, CategoriesBaseState>(
      'LoadInitialDataEvent should emit success for both categories and products',
      build: () {
        final categoriesSuccess = SuccessBaseResponse<List<CategoryEntity>>(
          data: const [CategoryEntity(id: '1')],
        );
        final productsSuccess = SuccessBaseResponse<List<ProductEntity>>(
          data: const [ProductEntity(id: '1')],
        );

        when(
          mockGetCategoriesUseCase.execute(),
        ).thenAnswer((_) async => categoriesSuccess);

        when(
          mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).thenAnswer((_) async => productsSuccess);

        return viewModel;
      },
      act: (cubit) => cubit.doEvent(const LoadInitialDataEvent()),
      expect: () => [
        const CategoriesLoading(),
        const CategoriesSuccess([CategoryEntity(id: '1')]),
        const ProductsLoading(),
        const ProductsSuccess(
          products: [ProductEntity(id: '1')],
          selectedCategoryId: null,
        ),
      ],
      verify: (_) {
        verify(mockGetCategoriesUseCase.execute()).called(1);
        verify(
          mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).called(1);
      },
    );

    blocTest<CategoriesViewModel, CategoriesBaseState>(
      'CategorySelectedEvent should fetch products for the given category id',
      build: () {
        final productsSuccess = SuccessBaseResponse<List<ProductEntity>>(
          data: const [ProductEntity(id: '1', categoryId: '123')],
        );

        when(
          mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).thenAnswer((_) async => productsSuccess);

        return viewModel;
      },
      act: (cubit) => cubit.doEvent(const CategorySelectedEvent('123')),
      expect: () => [
        const ProductsLoading(),
        const ProductsSuccess(
          products: [ProductEntity(id: '1', categoryId: '123')],
          selectedCategoryId: '123',
        ),
      ],
      verify: (_) {
        verify(
          mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).called(1);
      },
    );

    blocTest<CategoriesViewModel, CategoriesBaseState>(
      'SortSelectedEvent should sort the fetched products locally without API call',
      build: () {
        final productsSuccess = SuccessBaseResponse<List<ProductEntity>>(
          data: const [
            ProductEntity(id: '1', price: 100),
            ProductEntity(id: '2', price: 50),
          ],
        );

        when(
          mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'),
          ),
        ).thenAnswer((_) async => productsSuccess);

        return viewModel;
      },
      act: (cubit) async {
        // Fetch products first so they are cached
        cubit.doEvent(const AllProductsSelectedEvent());
        // Wait for fetch to complete
        await Future.delayed(const Duration(milliseconds: 100));
        // Apply sort
        cubit.doEvent(const SortSelectedEvent(SortType.lowestPrice));
      },
      skip: 2, // Skip ProductsLoading and initial ProductsSuccess
      expect: () => [
        const ProductsSuccess(
          products: [
            ProductEntity(id: '2', price: 50),
            ProductEntity(id: '1', price: 100),
          ],
          selectedCategoryId: null,
        ),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/metadata_entity.dart';
import 'package:flower_app/features/home/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/home/domain/entities/category_entity.dart';
import 'package:flower_app/features/home/domain/entities/product_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:flower_app/features/home/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:flower_app/features/home/presentation/view_models/categories_view_model/categories_events.dart';
import 'package:flower_app/features/home/presentation/view_models/categories_view_model/categories_states.dart';
import 'package:flower_app/features/home/presentation/view_models/categories_view_model/categories_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'categories_view_model_test.mocks.dart';

const _tCategory = CategoryEntity(id: '1');
const _tProduct = ProductEntity(id: '1');

@GenerateMocks([GetCategoriesUseCase, GetProductsByCategoryUseCase])
void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductsByCategoryUseCase mockGetProductsByCategoryUseCase;
  late CategoriesViewModel viewModel;

  setUpAll(() {
    provideDummy<BaseResponse<CategoriesResponseEntity>>(
      SuccessBaseResponse<CategoriesResponseEntity>(
        data: const CategoriesResponseEntity(categories: []),
      ),
    );
    provideDummy<BaseResponse<ProductsResponseEntity>>(
      SuccessBaseResponse<ProductsResponseEntity>(
        data: const ProductsResponseEntity(products: []),
      ),
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
    test('initial state is CategoriesState with all BaseState defaults', () {
      expect(viewModel.state, equals(const CategoriesState()));
      expect(viewModel.state.categoriesState.isLoading, isFalse);
      expect(viewModel.state.productsState.isLoading, isFalse);
    });

    blocTest<CategoriesViewModel, CategoriesState>(
      'LoadInitialDataEvent emits loading then success for categories and products',
      build: () {
        when(mockGetCategoriesUseCase.execute(page: 1, limit: 50))
            .thenAnswer((_) async =>
            SuccessBaseResponse(
              data: const CategoriesResponseEntity(
                categories: [_tCategory],
                metadata: MetadataEntity(
                    currentPage: 1, totalPages: 1, limit: 50),
              ),
            ));
        when(mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'), page: 1, limit: 10))
            .thenAnswer((_) async =>
            SuccessBaseResponse(
              data: const ProductsResponseEntity(
                products: [_tProduct],
                metadata: MetadataEntity(
                    currentPage: 1, totalPages: 1, limit: 10),
              ),
            ));
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(LoadInitialDataEvent()),
      expect: () => [
        CategoriesState(
            categoriesState: BaseState<List<CategoryEntity>>.loading()),
        CategoriesState(
          categoriesState: BaseState.success(const [_tCategory]),
        ),
        CategoriesState(
          categoriesState: BaseState.success(const [_tCategory]),
          productsState: BaseState<ProductsResponseEntity>.loading(),
          selectedCategoryId: null,
        ),
        isA<CategoriesState>().having(
              (s) => s.productsState.data?.products,
          'products loaded',
          contains(_tProduct),
        ),
      ],
    );

    blocTest<CategoriesViewModel, CategoriesState>(
      'CategorySelectedEvent fetches products for the selected category',
      build: () {
        when(mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'), page: 1, limit: 10))
            .thenAnswer((_) async =>
            SuccessBaseResponse(
              data: const ProductsResponseEntity(
                products: [ProductEntity(id: '1', categoryId: '123')],
                metadata: MetadataEntity(
                    currentPage: 1, totalPages: 1, limit: 10),
              ),
            ));
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(CategorySelectedEvent('123')),
      expect: () => [
        CategoriesState(
          productsState: BaseState<ProductsResponseEntity>.loading(),
          selectedCategoryId: '123',
        ),
        isA<CategoriesState>()
            .having((s) => s.selectedCategoryId, 'selectedCategoryId', '123')
            .having(
              (s) => s.productsState.data?.products.first.categoryId,
          'product categoryId',
          '123',
        ),
      ],
    );

    blocTest<CategoriesViewModel, CategoriesState>(
      'RefreshEvent re-fetches products for the currently selected category',
      build: () {
        when(mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'), page: 1, limit: 10))
            .thenAnswer((_) async =>
            SuccessBaseResponse(
              data: const ProductsResponseEntity(
                products: [_tProduct],
                metadata: MetadataEntity(
                    currentPage: 1, totalPages: 1, limit: 10),
              ),
            ));
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(RefreshEvent()),
      expect: () => [
        CategoriesState(
          productsState: BaseState<ProductsResponseEntity>.loading(),
          selectedCategoryId: null,
        ),
        isA<CategoriesState>().having(
              (s) => s.productsState.data?.products,
          'products refreshed',
          contains(_tProduct),
        ),
      ],
    );

    blocTest<CategoriesViewModel, CategoriesState>(
      'CategorySelectedEvent emits productsState error when products API fails',
      build: () {
        when(mockGetProductsByCategoryUseCase.execute(
            requestModel: anyNamed('requestModel'), page: 1, limit: 10))
            .thenAnswer((_) async =>
            ErrorBaseResponse(exception: Exception('Server error')));
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(CategorySelectedEvent('abc')),
      expect: () =>
      [
        CategoriesState(
          productsState: BaseState<ProductsResponseEntity>.loading(),
          selectedCategoryId: 'abc',
        ),
        isA<CategoriesState>().having(
              (s) => s.productsState.msg,
          'products error present',
          isNotNull,
        ),
      ],
    );
  });
}

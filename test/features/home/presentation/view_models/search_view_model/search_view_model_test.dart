import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/metadata_entity.dart';
import 'package:flower_app/features/home/domain/entities/product_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/home/domain/use_cases/search_products_use_case.dart';
import 'package:flower_app/features/home/presentation/view_models/search_view_model/search_events.dart';
import 'package:flower_app/features/home/presentation/view_models/search_view_model/search_states.dart';
import 'package:flower_app/features/home/presentation/view_models/search_view_model/search_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'search_view_model_test.mocks.dart';

const _tProduct = ProductEntity(id: '1');

@GenerateMocks([SearchProductsUseCase])
void main() {
  late MockSearchProductsUseCase mockSearchProductsUseCase;
  late SearchViewModel viewModel;

  setUpAll(() {
    provideDummy<BaseResponse<ProductsResponseEntity>>(
      SuccessBaseResponse<ProductsResponseEntity>(
        data: const ProductsResponseEntity(products: []),
      ),
    );
  });

  setUp(() {
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    viewModel = SearchViewModel(mockSearchProductsUseCase);
  });

  group('SearchViewModel', () {
    test(
      'initial state is SearchState with isInitial=true and default BaseState',
      () {
        expect(viewModel.state, equals(const SearchState()));
        expect(viewModel.state.isInitial, isTrue);
        expect(viewModel.state.productsState.isLoading, isFalse);
      },
    );

    blocTest<SearchViewModel, SearchState>(
      'SearchSubmittedEvent emits loading then success with products',
      build: () {
        when(mockSearchProductsUseCase.execute(query: 'rose')).thenAnswer(
          (_) async => SuccessBaseResponse(
            data: const ProductsResponseEntity(
              products: [_tProduct],
              metadata: MetadataEntity(
                currentPage: 1,
                totalPages: 1,
                limit: 40,
              ),
            ),
          ),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(SearchSubmittedEvent('rose')),
      expect: () => [
        SearchState(
          productsState: BaseState<List<ProductEntity>>.loading(),
          isInitial: false,
        ),
        isA<SearchState>().having(
          (s) => s.productsState.data,
          'products loaded',
          contains(_tProduct),
        ),
      ],
    );

    blocTest<SearchViewModel, SearchState>(
      'SearchSubmittedEvent emits loading then error when use case fails',
      build: () {
        when(mockSearchProductsUseCase.execute(query: 'rose')).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('Server error')),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(SearchSubmittedEvent('rose')),
      expect: () => [
        SearchState(
          productsState: BaseState<List<ProductEntity>>.loading(),
          isInitial: false,
        ),
        isA<SearchState>().having(
          (s) => s.productsState.msg,
          'error message present',
          isNotNull,
        ),
      ],
    );

    blocTest<SearchViewModel, SearchState>(
      'SearchClearedEvent resets state to initial',
      build: () => viewModel,
      seed: () => SearchState(
        productsState: BaseState.success(const [_tProduct]),
        isInitial: false,
      ),
      act: (cubit) => cubit.doEvent(SearchClearedEvent()),
      expect: () => [const SearchState()],
    );

    blocTest<SearchViewModel, SearchState>(
      'SearchSubmittedEvent with empty query emits nothing',
      build: () => viewModel,
      act: (cubit) => cubit.doEvent(SearchSubmittedEvent('   ')),
      expect: () => [],
    );

    blocTest<SearchViewModel, SearchState>(
      'SearchSubmittedEvent emits success with empty products list when no results',
      build: () {
        when(mockSearchProductsUseCase.execute(query: 'xyz')).thenAnswer(
          (_) async => SuccessBaseResponse(
            data: const ProductsResponseEntity(products: []),
          ),
        );
        return viewModel;
      },
      act: (cubit) => cubit.doEvent(SearchSubmittedEvent('xyz')),
      expect: () => [
        SearchState(
          productsState: BaseState<List<ProductEntity>>.loading(),
          isInitial: false,
        ),
        isA<SearchState>().having(
          (s) => s.productsState.data,
          'products list is empty',
          isEmpty,
        ),
      ],
    );
  });
}

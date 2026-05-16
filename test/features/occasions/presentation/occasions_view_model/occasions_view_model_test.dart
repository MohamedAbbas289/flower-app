import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/occasions/domain/entities/products_entity.dart';
import 'package:flower_app/features/occasions/domain/usecases/get_occasions_use_case.dart';
import 'package:flower_app/features/occasions/domain/usecases/get_products_by_occasiousecase.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_events.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_state.dart';
import 'package:flower_app/features/occasions/presentation/occasions_view_model/occasions_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occasions_view_model_test.mocks.dart';

@GenerateMocks([GetOccasionsUseCase, GetProductsByOccasionUseCase])
void main() {
  setUpAll(() {
    provideDummy<BaseResponse<OccasionsEntity>>(
      SuccessBaseResponse<OccasionsEntity>(
        data: const OccasionsEntity(
          occasions: [],
          currentPage: 1,
          totalPages: 1,
        ),
      ),
    );
    provideDummy<BaseResponse<ProductsEntity>>(
      SuccessBaseResponse<ProductsEntity>(
        data: const ProductsEntity(products: [], currentPage: 1, totalPages: 1),
      ),
    );
  });

  late MockGetOccasionsUseCase mockGetOccasionsUseCase;
  late MockGetProductsByOccasionUseCase mockGetProductsByOccasionUseCase;
  late OccasionsViewModel sut;

  const occasionId1 = 'occasion-1';
  const occasionId2 = 'occasion-2';

  final occasion1 = const OccasionEntity(
    id: occasionId1,
    name: 'Wedding',
    productsCount: 13,
  );

  final occasion2 = const OccasionEntity(
    id: occasionId2,
    name: 'Graduation',
    productsCount: 6,
  );

  final occasionsPageOne = OccasionsEntity(
    occasions: [occasion1, occasion2],
    currentPage: 1,
    totalPages: 2,
  );

  final occasionsPageTwo = OccasionsEntity(
    occasions: [
      const OccasionEntity(
        id: 'occasion-3',
        name: 'Birthday',
        productsCount: 2,
      ),
    ],
    currentPage: 2,
    totalPages: 2,
  );

  final product1 = const ProductEntity(
    id: 'product-1',
    name: 'Wedding Flower',
    imageUrl: 'https://example.com/cover.png',
    price: 100,
    originalPrice: 300,
    discountPercent: 60,
  );

  final product2 = const ProductEntity(
    id: 'product-2',
    name: 'Red Wedding Flower',
    imageUrl: 'https://example.com/red.png',
    price: 150,
    originalPrice: 500,
    discountPercent: 40,
  );

  final productsPageOne = ProductsEntity(
    products: [product1, product2],
    currentPage: 1,
    totalPages: 3,
  );

  final productsPageTwo = ProductsEntity(
    products: [
      const ProductEntity(
        id: 'product-3',
        name: 'Red Rose Bouquet',
        imageUrl: 'https://example.com/rose.png',
        price: 150,
        originalPrice: 200,
        discountPercent: 50,
      ),
    ],
    currentPage: 2,
    totalPages: 3,
  );

  void stubGetOccasionsSuccess({
    required OccasionsEntity data,
    int page = 1,
    int limit = 10,
  }) {
    when(
      mockGetOccasionsUseCase.execute(page: page, limit: limit),
    ).thenAnswer((_) async => SuccessBaseResponse<OccasionsEntity>(data: data));
  }

  void stubGetOccasionsError({
    required Object exception,
    int page = 1,
    int limit = 10,
  }) {
    when(mockGetOccasionsUseCase.execute(page: page, limit: limit)).thenAnswer(
      (_) async => ErrorBaseResponse<OccasionsEntity>(exception: exception),
    );
  }

  void stubGetProductsSuccess({
    required ProductsEntity data,
    required String occasionId,
    int page = 1,
    int limit = 10,
  }) {
    when(
      mockGetProductsByOccasionUseCase.execute(
        occasionId: occasionId,
        page: page,
        limit: limit,
      ),
    ).thenAnswer((_) async => SuccessBaseResponse<ProductsEntity>(data: data));
  }

  void stubGetProductsError({
    required Object exception,
    required String occasionId,
    int page = 1,
    int limit = 10,
  }) {
    when(
      mockGetProductsByOccasionUseCase.execute(
        occasionId: occasionId,
        page: page,
        limit: limit,
      ),
    ).thenAnswer(
      (_) async => ErrorBaseResponse<ProductsEntity>(exception: exception),
    );
  }

  setUp(() {
    mockGetOccasionsUseCase = MockGetOccasionsUseCase();
    mockGetProductsByOccasionUseCase = MockGetProductsByOccasionUseCase();
    sut = OccasionsViewModel(
      mockGetOccasionsUseCase,
      mockGetProductsByOccasionUseCase,
    );
  });

  tearDown(() => sut.close());

  group('Initial state', () {
    test('emits the correct initial state on creation', () {
      expect(sut.state, const OccasionsState());
      expect(sut.state.occasionsState.isLoading, isFalse);
      expect(sut.state.productsState.isLoading, isFalse);
      expect(sut.state.selectedOccasionId, isNull);
      expect(sut.state.isLoadingMore, isFalse);
      expect(sut.state.isLoadingMoreOccasions, isFalse);
      expect(sut.state.currentPage, 1);
      expect(sut.state.totalPages, 1);
      expect(sut.state.paginationResetKey, 0);
    });
  });

  group('GetOccasionsEvent', () {
    group('success with non-empty occasions — no initialOccasionId', () {
      blocTest<OccasionsViewModel, OccasionsState>(
        'selects first occasion when no initialOccasionId provided',
        build: () {
          stubGetOccasionsSuccess(data: occasionsPageOne);
          stubGetProductsSuccess(
            data: productsPageOne,
            occasionId: occasionId1,
          );
          return sut;
        },
        act: (vm) => vm.doEvent(GetOccasionsEvent()),
        expect: () => [
          isA<OccasionsState>().having(
            (s) => s.occasionsState.isLoading,
            'occasionsState.isLoading',
            isTrue,
          ),
          isA<OccasionsState>()
              .having(
                (s) => s.occasionsState.data,
                'occasionsState.data',
                [occasion1, occasion2],
              )
              .having(
                (s) => s.occasionsCurrentPage,
                'occasionsCurrentPage',
                1,
              )
              .having((s) => s.occasionsTotalPages, 'occasionsTotalPages', 2),
          isA<OccasionsState>()
              .having(
                (s) => s.productsState.isLoading,
                'productsState.isLoading',
                isTrue,
              )
              .having(
                (s) => s.selectedOccasionId,
                'selectedOccasionId',
                occasionId1,
              )
              .having((s) => s.paginationResetKey, 'paginationResetKey', 1),
          isA<OccasionsState>()
              .having(
                (s) => s.productsState.data,
                'productsState.data',
                [product1, product2],
              )
              .having((s) => s.currentPage, 'currentPage', 1)
              .having((s) => s.totalPages, 'totalPages', 3),
        ],
        verify: (_) {
          verify(mockGetOccasionsUseCase.execute(page: 1, limit: 10)).called(1);
          verify(
            mockGetProductsByOccasionUseCase.execute(
              occasionId: occasionId1,
              page: 1,
              limit: 10,
            ),
          ).called(1);
        },
      );
    });

    group('success with non-empty occasions — with initialOccasionId', () {
      blocTest<OccasionsViewModel, OccasionsState>(
        'selects initialOccasionId when it exists in the list',
        build: () {
          stubGetOccasionsSuccess(data: occasionsPageOne);
          stubGetProductsSuccess(
            data: productsPageOne,
            occasionId: occasionId2,
          );
          return sut;
        },
        act: (vm) =>
            vm.doEvent(GetOccasionsEvent(initialOccasionId: occasionId2)),
        expect: () => [
          isA<OccasionsState>().having(
            (s) => s.occasionsState.isLoading,
            'occasionsState.isLoading',
            isTrue,
          ),
          isA<OccasionsState>().having(
            (s) => s.occasionsState.data,
            'occasionsState.data',
            [occasion1, occasion2],
          ),
          isA<OccasionsState>()
              .having(
                (s) => s.productsState.isLoading,
                'productsState.isLoading',
                isTrue,
              )
              .having(
                (s) => s.selectedOccasionId,
                'selectedOccasionId',
                occasionId2,
              ),
          isA<OccasionsState>().having(
            (s) => s.productsState.data,
            'productsState.data',
            [product1, product2],
          ),
        ],
        verify: (_) {
          verify(
            mockGetProductsByOccasionUseCase.execute(
              occasionId: occasionId2,
              page: 1,
              limit: 10,
            ),
          ).called(1);
        },
      );

      blocTest<OccasionsViewModel, OccasionsState>(
        'falls back to first occasion when initialOccasionId not in list',
        build: () {
          stubGetOccasionsSuccess(data: occasionsPageOne);
          stubGetProductsSuccess(
            data: productsPageOne,
            occasionId: occasionId1,
          );
          return sut;
        },
        act: (vm) => vm.doEvent(
          GetOccasionsEvent(initialOccasionId: 'non-existent-id'),
        ),
        expect: () => [
          isA<OccasionsState>().having(
            (s) => s.occasionsState.isLoading,
            'loading',
            isTrue,
          ),
          isA<OccasionsState>().having(
            (s) => s.occasionsState.data,
            'data',
            [occasion1, occasion2],
          ),
          isA<OccasionsState>().having(
            (s) => s.selectedOccasionId,
            'selectedOccasionId falls back to first',
            occasionId1,
          ),
          isA<OccasionsState>().having(
            (s) => s.productsState.data,
            'productsState.data',
            [product1, product2],
          ),
        ],
        verify: (_) {
          verify(
            mockGetProductsByOccasionUseCase.execute(
              occasionId: occasionId1,
              page: 1,
              limit: 10,
            ),
          ).called(1);
        },
      );
    });

    group('success with empty occasions', () {
      blocTest<OccasionsViewModel, OccasionsState>(
        'does NOT trigger GetProductsByOccasionEvent when occasions list is empty',
        build: () {
          stubGetOccasionsSuccess(
            data: OccasionsEntity(
              occasions: [],
              currentPage: 1,
              totalPages: 1,
            ),
          );
          return sut;
        },
        act: (vm) => vm.doEvent(GetOccasionsEvent()),
        expect: () => [
          isA<OccasionsState>().having(
            (s) => s.occasionsState.isLoading,
            'loading',
            isTrue,
          ),
          isA<OccasionsState>().having(
            (s) => s.occasionsState.data,
            'data',
            isEmpty,
          ),
        ],
        verify: (_) {
          verifyNever(
            mockGetProductsByOccasionUseCase.execute(
              occasionId: anyNamed('occasionId'),
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          );
        },
      );
    });

    group('failure', () {
      blocTest<OccasionsViewModel, OccasionsState>(
        'emits loading → error state on network failure',
        build: () {
          stubGetOccasionsError(exception: Exception('Network error'));
          return sut;
        },
        act: (vm) => vm.doEvent(GetOccasionsEvent()),
        expect: () => [
          isA<OccasionsState>().having(
            (s) => s.occasionsState.isLoading,
            'loading',
            isTrue,
          ),
          isA<OccasionsState>().having(
            (s) => s.occasionsState.msg,
            'error msg',
            isNotNull,
          ),
        ],
        verify: (_) {
          verifyNever(
            mockGetProductsByOccasionUseCase.execute(
              occasionId: anyNamed('occasionId'),
              page: anyNamed('page'),
              limit: anyNamed('limit'),
            ),
          );
        },
      );
    });
  });

  group('GetProductsByOccasionEvent', () {
    blocTest<OccasionsViewModel, OccasionsState>(
      'emits correct states on success',
      build: () {
        stubGetProductsSuccess(data: productsPageOne, occasionId: occasionId1);
        return sut;
      },
      act: (vm) =>
          vm.doEvent(GetProductsByOccasionEvent(occasionId: occasionId1)),
      expect: () => [
        isA<OccasionsState>()
            .having(
              (s) => s.productsState.isLoading,
              'productsState.isLoading',
              isTrue,
            )
            .having(
              (s) => s.selectedOccasionId,
              'selectedOccasionId',
              occasionId1,
            )
            .having((s) => s.currentPage, 'currentPage reset', 1)
            .having((s) => s.totalPages, 'totalPages reset', 1)
            .having((s) => s.paginationResetKey, 'paginationResetKey', 1),
        isA<OccasionsState>()
            .having(
              (s) => s.productsState.data,
              'productsState.data',
              [product1, product2],
            )
            .having((s) => s.currentPage, 'currentPage', 1)
            .having((s) => s.totalPages, 'totalPages', 3),
      ],
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'increments paginationResetKey on each different occasion selection',
      build: () {
        stubGetProductsSuccess(data: productsPageOne, occasionId: occasionId1);
        stubGetProductsSuccess(data: productsPageOne, occasionId: occasionId2);
        return sut;
      },
      act: (vm) async {
        vm.doEvent(GetProductsByOccasionEvent(occasionId: occasionId1));
        await Future.delayed(Duration.zero);
        vm.doEvent(GetProductsByOccasionEvent(occasionId: occasionId2));
      },
      verify: (vm) {
        expect(vm.state.paginationResetKey, 2);
        expect(vm.state.selectedOccasionId, occasionId2);
      },
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'emits error state on failure',
      build: () {
        stubGetProductsError(
          exception: Exception('Server error'),
          occasionId: occasionId1,
        );
        return sut;
      },
      act: (vm) =>
          vm.doEvent(GetProductsByOccasionEvent(occasionId: occasionId1)),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.productsState.isLoading,
          'loading',
          isTrue,
        ),
        isA<OccasionsState>().having(
          (s) => s.productsState.msg,
          'error msg',
          isNotNull,
        ),
      ],
    );
  });

  group('LoadMoreProductsEvent', () {
    blocTest<OccasionsViewModel, OccasionsState>(
      'appends next page products on success',
      build: () {
        stubGetProductsSuccess(
          data: productsPageTwo,
          occasionId: occasionId1,
          page: 2,
        );
        return sut;
      },
      seed: () => OccasionsState(
        selectedOccasionId: occasionId1,
        currentPage: 1,
        totalPages: 3,
        productsState: BaseState.success([product1, product2]),
      ),
      act: (vm) => vm.doEvent(LoadMoreProductsEvent()),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.isLoadingMore,
          'isLoadingMore',
          isTrue,
        ),
        isA<OccasionsState>()
            .having((s) => s.isLoadingMore, 'isLoadingMore', isFalse)
            .having((s) => s.productsState.data?.length, 'products count', 3)
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.totalPages, 'totalPages', 3),
      ],
      verify: (_) {
        verify(
          mockGetProductsByOccasionUseCase.execute(
            occasionId: occasionId1,
            page: 2,
            limit: 10,
          ),
        ).called(1);
      },
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'does nothing when already loading more',
      build: () => sut,
      seed: () => const OccasionsState(
        selectedOccasionId: occasionId1,
        isLoadingMore: true,
        currentPage: 1,
        totalPages: 3,
      ),
      act: (vm) => vm.doEvent(LoadMoreProductsEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(
          mockGetProductsByOccasionUseCase.execute(
            occasionId: anyNamed('occasionId'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        );
      },
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'does nothing when selectedOccasionId is null',
      build: () => sut,
      seed: () => const OccasionsState(
        selectedOccasionId: null,
        currentPage: 1,
        totalPages: 3,
      ),
      act: (vm) => vm.doEvent(LoadMoreProductsEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(
          mockGetProductsByOccasionUseCase.execute(
            occasionId: anyNamed('occasionId'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        );
      },
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'does nothing when already on last page',
      build: () => sut,
      seed: () => const OccasionsState(
        selectedOccasionId: occasionId1,
        currentPage: 3,
        totalPages: 3,
      ),
      act: (vm) => vm.doEvent(LoadMoreProductsEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(
          mockGetProductsByOccasionUseCase.execute(
            occasionId: anyNamed('occasionId'),
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        );
      },
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'resets isLoadingMore to false on failure',
      build: () {
        stubGetProductsError(
          exception: Exception('error'),
          occasionId: occasionId1,
          page: 2,
        );
        return sut;
      },
      seed: () => OccasionsState(
        selectedOccasionId: occasionId1,
        currentPage: 1,
        totalPages: 3,
        productsState: BaseState.success([product1]),
      ),
      act: (vm) => vm.doEvent(LoadMoreProductsEvent()),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.isLoadingMore,
          'isLoadingMore true',
          isTrue,
        ),
        isA<OccasionsState>().having(
          (s) => s.isLoadingMore,
          'isLoadingMore false after error',
          isFalse,
        ),
      ],
    );
  });

  group('LoadMoreOccasionsEvent', () {
    blocTest<OccasionsViewModel, OccasionsState>(
      'appends next page occasions on success',
      build: () {
        stubGetOccasionsSuccess(data: occasionsPageTwo, page: 2);
        return sut;
      },
      seed: () => OccasionsState(
        occasionsCurrentPage: 1,
        occasionsTotalPages: 2,
        occasionsState: BaseState.success([occasion1, occasion2]),
      ),
      act: (vm) => vm.doEvent(LoadMoreOccasionsEvent()),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.isLoadingMoreOccasions,
          'isLoadingMoreOccasions',
          isTrue,
        ),
        isA<OccasionsState>()
            .having(
              (s) => s.isLoadingMoreOccasions,
              'isLoadingMoreOccasions',
              isFalse,
            )
            .having((s) => s.occasionsState.data?.length, 'occasions count', 3)
            .having((s) => s.occasionsCurrentPage, 'occasionsCurrentPage', 2)
            .having((s) => s.occasionsTotalPages, 'occasionsTotalPages', 2),
      ],
      verify: (_) {
        verify(mockGetOccasionsUseCase.execute(page: 2, limit: 10)).called(1);
      },
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'does nothing when already loading more occasions',
      build: () => sut,
      seed: () => const OccasionsState(
        isLoadingMoreOccasions: true,
        occasionsCurrentPage: 1,
        occasionsTotalPages: 2,
      ),
      act: (vm) => vm.doEvent(LoadMoreOccasionsEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(
          mockGetOccasionsUseCase.execute(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        );
      },
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'does nothing when already on last occasions page',
      build: () => sut,
      seed: () => const OccasionsState(
        occasionsCurrentPage: 2,
        occasionsTotalPages: 2,
      ),
      act: (vm) => vm.doEvent(LoadMoreOccasionsEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(
          mockGetOccasionsUseCase.execute(
            page: anyNamed('page'),
            limit: anyNamed('limit'),
          ),
        );
      },
    );

    blocTest<OccasionsViewModel, OccasionsState>(
      'resets isLoadingMoreOccasions to false on failure',
      build: () {
        stubGetOccasionsError(exception: Exception('error'), page: 2);
        return sut;
      },
      seed: () => OccasionsState(
        occasionsCurrentPage: 1,
        occasionsTotalPages: 2,
        occasionsState: BaseState.success([occasion1]),
      ),
      act: (vm) => vm.doEvent(LoadMoreOccasionsEvent()),
      expect: () => [
        isA<OccasionsState>().having(
          (s) => s.isLoadingMoreOccasions,
          'isLoadingMoreOccasions true',
          isTrue,
        ),
        isA<OccasionsState>().having(
          (s) => s.isLoadingMoreOccasions,
          'isLoadingMoreOccasions false after error',
          isFalse,
        ),
      ],
    );
  });
}
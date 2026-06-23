import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/best_seller/domain/entity/best_seller_product_entity.dart';
import 'package:flower_app/features/best_seller/domain/use_case/fetch_best_seller_use_case.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_cubit.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_event.dart';
import 'package:flower_app/features/best_seller/presentation/view_model/best_seller_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'best_seller_cubit_test.mocks.dart';

@GenerateMocks([FetchBestSellerUseCase])
void main() {
  late MockFetchBestSellerUseCase mockFetchBestSellerUseCase;
  late BestSellerCubit bestSellerCubit;

  final tProduct = BestSellerProductEntity(
    productId: "69d988754461df0f939b5817",
    title: "Wdding Flower",
    productPrice: 300,
    priceAfterDiscount: 100,
    discount: 60,
    imgCover:
        "https://flower.elevateegy.com/uploads/fefa790a-f0c1-42a0-8699-34e8fc065812-cover_image.png",
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<BestSellerProductEntity>>>(
      SuccessBaseResponse<List<BestSellerProductEntity>>(data: const []),
    );
  });

  setUp(() {
    mockFetchBestSellerUseCase = MockFetchBestSellerUseCase();
    bestSellerCubit = BestSellerCubit(
      fetchBestSellerUseCase: mockFetchBestSellerUseCase,
    );
  });

  group('BestSellerCubit', () {
    test('initial state should be const BestSellerState()', () {
      expect(bestSellerCubit.state, equals(const BestSellerState()));
    });

    blocTest<BestSellerCubit, BestSellerState>(
      'should emit loading then success when fetch best sellers succeeds',
      build: () {
        when(mockFetchBestSellerUseCase.call()).thenAnswer(
          (_) async => SuccessBaseResponse<List<BestSellerProductEntity>>(
            data: [tProduct],
          ),
        );
        return bestSellerCubit;
      },
      act: (cubit) => cubit.doEvent(FetchBestSellerProductsEvent()),
      expect: () => [
        BestSellerState(bestSellerState: BaseState.loading()),
        BestSellerState(bestSellerState: BaseState.success([tProduct])),
      ],
      verify: (_) {
        verify(mockFetchBestSellerUseCase.call()).called(1);
        verifyNoMoreInteractions(mockFetchBestSellerUseCase);
      },
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'should emit loading then error when fetch best sellers fails',
      build: () {
        when(mockFetchBestSellerUseCase.call()).thenAnswer(
          (_) async => ErrorBaseResponse<List<BestSellerProductEntity>>(
            exception: Exception('network error'),
          ),
        );
        return bestSellerCubit;
      },
      act: (cubit) => cubit.doEvent(FetchBestSellerProductsEvent()),
      expect: () => [
        BestSellerState(bestSellerState: BaseState.loading()),
        BestSellerState(bestSellerState: BaseState.error('somethingWentWrong')),
      ],
    );

    blocTest<BestSellerCubit, BestSellerState>(
      'RefreshBestSellerEvent emits loading then success same as fetch',
      build: () {
        when(mockFetchBestSellerUseCase.call()).thenAnswer(
          (_) async => SuccessBaseResponse<List<BestSellerProductEntity>>(
            data: [tProduct],
          ),
        );
        return bestSellerCubit;
      },
      act: (cubit) => cubit.doEvent(RefreshBestSellerEvent()),
      expect: () => [
        BestSellerState(bestSellerState: BaseState.loading()),
        BestSellerState(bestSellerState: BaseState.success([tProduct])),
      ],
      verify: (_) {
        verify(mockFetchBestSellerUseCase.call()).called(1);
      },
    );
  });
}
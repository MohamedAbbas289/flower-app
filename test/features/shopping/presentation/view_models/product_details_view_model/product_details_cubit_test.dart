import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/shopping/domain/use_cases/product_details_use_case.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_view_model.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_events.dart';
import 'package:flower_app/features/shopping/presentation/view_models/product_details_view_model/product_details_states.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'product_details_cubit_test.mocks.dart';

@GenerateMocks([ProductDetailsUseCase])
void main() {
  late ProductDetailsViewModel cubit;
  late MockProductDetailsUseCase mockUseCase;

  const tProductId = '69d988754461df0f939b581a';

  final tEntity = ProductDetailsEntity(
    id: tProductId,
    title: 'Pink Rose Bouquet',
    description: 'Lorem ipsum',
    images: ['https://example.com/image.jpg'],
    price: 1500,
    priceAfterDiscount: 1200,
    quantity: 10,
    rateCount: 5,
    rateAvg: 4.5,
    isInWishlist: false,
  );

  setUpAll(() {
    provideDummy<BaseResponse<ProductDetailsEntity>>(
      SuccessBaseResponse<ProductDetailsEntity>(data: tEntity),
    );
    provideDummy<BaseResponse<ProductDetailsEntity>>(
      ErrorBaseResponse<ProductDetailsEntity>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockUseCase = MockProductDetailsUseCase();
    cubit = ProductDetailsViewModel(mockUseCase);
  });

  tearDown(() => cubit.close());

  group('GetProductDetailsEvent', () {
    blocTest<ProductDetailsViewModel, ProductDetailsBaseState>(
      'emits loading then success on success',
      build: () {
        when(
          mockUseCase.execute(productId: anyNamed('productId')),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));
        return cubit;
      },
      act: (c) =>
          c.doEvent(const GetProductDetailsEvent(productId: tProductId)),
      expect: () => [
        isA<ProductDetailsBaseState>().having(
          (s) => s.productDetailsState.isLoading,
          'isLoading',
          true,
        ),
        isA<ProductDetailsBaseState>()
            .having((s) => s.productDetailsState.isLoading, 'isLoading', false)
            .having((s) => s.productDetailsState.data, 'data', tEntity),
      ],
    );

    blocTest<ProductDetailsViewModel, ProductDetailsBaseState>(
      'emits loading then error on failure',
      build: () {
        when(
          mockUseCase.execute(productId: anyNamed('productId')),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
        return cubit;
      },
      act: (c) =>
          c.doEvent(const GetProductDetailsEvent(productId: tProductId)),
      expect: () => [
        isA<ProductDetailsBaseState>().having(
          (s) => s.productDetailsState.isLoading,
          'isLoading',
          true,
        ),
        isA<ProductDetailsBaseState>()
            .having((s) => s.productDetailsState.isLoading, 'isLoading', false)
            .having((s) => s.productDetailsState.data, 'data', null)
            .having((s) => s.productDetailsState.msg, 'msg', isNotNull),
      ],
    );
  });
}

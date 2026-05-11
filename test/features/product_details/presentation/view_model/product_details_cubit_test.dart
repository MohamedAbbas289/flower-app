import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/product_details/domain/use_case/product_details_use_case.dart';
import 'package:flower_app/features/product_details/presentation/view_model/product_details_cubit.dart';
import 'package:flower_app/features/product_details/presentation/view_model/product_details_states.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'product_details_cubit_test.mocks.dart';

@GenerateMocks([ProductDetailsUseCase])
void main() {
  late ProductDetailsCubit cubit;
  late MockProductDetailsUseCase mockProductDetailsUseCase;

  final tEntity = ProductDetailsEntity(
    id: '69d988754461df0f939b581a',
    title: 'Pink Rose Bouquet',
    description: 'Lorem ipsum',
    imgCover: 'https://example.com/image.jpg',
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
    mockProductDetailsUseCase = MockProductDetailsUseCase();
    cubit = ProductDetailsCubit(mockProductDetailsUseCase);
  });

  tearDown(() => cubit.close());

  group('getProductDetails', () {
    blocTest<ProductDetailsCubit, ProductDetailsBaseState>(
      'emits [ProductDetailsLoading, ProductDetailsSuccess] on success',
      build: () {
        when(
          mockProductDetailsUseCase.getProductDetails(),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));
        return cubit;
      },
      act: (c) => c.getProductDetails(),
      expect: () => [
        isA<ProductDetailsLoading>(),
        isA<ProductDetailsSuccess>().having((s) => s.entity, 'entity', tEntity),
      ],
    );

    blocTest<ProductDetailsCubit, ProductDetailsBaseState>(
      'emits [ProductDetailsLoading, ProductDetailsFailure] on failure',
      build: () {
        when(mockProductDetailsUseCase.getProductDetails()).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
        return cubit;
      },
      act: (c) => c.getProductDetails(),
      expect: () => [
        isA<ProductDetailsLoading>(),
        isA<ProductDetailsFailure>().having(
          (s) => s.error,
          'error',
          isNotEmpty,
        ),
      ],
    );
  });
}

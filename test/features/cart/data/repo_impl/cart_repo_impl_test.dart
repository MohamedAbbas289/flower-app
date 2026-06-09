import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/cart/data/data_source_contract/cart_remote_data_source_contract.dart';
import 'package:flower_app/features/cart/data/models/cart_model.dart';
import 'package:flower_app/features/cart/data/models/cart_response_model.dart';
import 'package:flower_app/features/cart/data/repo_impl/cart_repo_impl.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_repo_impl_test.mocks.dart';

@GenerateMocks([CartRemoteDataSourceContract])
void main() {
  late MockCartRemoteDataSourceContract mockDataSource;
  late CartRepoImpl repo;
  const tRequestModel = CartRequestModel(productId: 'product_123', quantity: 2);
  const tProductId = 'product_123';

  const tCartEntity = CartEntity(
    id: 'cart_1',
    cartItems: [],
    totalPrice: 100,
    totalPriceAfterDiscount: 90,
    discount: 10,
    numOfCartItems: 0,
  );

  const tEmptyCartEntity = CartEntity(
    id: '',
    cartItems: [],
    totalPrice: 0,
    totalPriceAfterDiscount: 0,
    discount: 0,
    numOfCartItems: 0,
  );

  const tCartModel = CartModel(
    id: 'cart_1',
    cartItems: [],
    totalPrice: 100,
    totalPriceAfterDiscount: 90,
    discount: 10,
  );

  const tCartResponseWithData = CartResponseModel(cart: tCartModel);
  const tCartResponseNullCart = CartResponseModel(cart: null);
  final tException = Exception('Something went wrong');

  setUp(() {
    mockDataSource = MockCartRemoteDataSourceContract();
    repo = CartRepoImpl(mockDataSource);
    provideDummy<BaseResponse<CartResponseModel>>(
      SuccessBaseResponse(data: tCartResponseNullCart),
    );
  });

  group('getCart', () {
    test(
      'returns SuccessBaseResponse with CartEntity when cart is not null',
      () async {
        when(mockDataSource.getCart()).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCartResponseWithData),
        );

        final result = await repo.getCart();

        expect(result, isA<SuccessBaseResponse<CartEntity>>());
        expect((result as SuccessBaseResponse).data, tCartEntity);
        verify(mockDataSource.getCart()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'returns SuccessBaseResponse with empty CartEntity when cart is null',
      () async {
        when(mockDataSource.getCart()).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCartResponseNullCart),
        );

        final result = await repo.getCart();

        expect(result, isA<SuccessBaseResponse<CartEntity>>());
        expect((result as SuccessBaseResponse).data, tEmptyCartEntity);
        verify(mockDataSource.getCart()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test('returns ErrorBaseResponse when data source returns error', () async {
      when(
        mockDataSource.getCart(),
      ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

      final result = await repo.getCart();

      expect(result, isA<ErrorBaseResponse<CartEntity>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockDataSource.getCart()).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('addToCart', () {
    test(
      'returns SuccessBaseResponse with CartEntity when cart is not null',
      () async {
        when(mockDataSource.addToCart(tRequestModel)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCartResponseWithData),
        );

        final result = await repo.addToCart(tRequestModel);
        expect(result, isA<SuccessBaseResponse<CartEntity>>());
        expect((result as SuccessBaseResponse).data, tCartEntity);
        verify(mockDataSource.addToCart(tRequestModel)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'returns SuccessBaseResponse with empty CartEntity when cart is null',
      () async {
        when(mockDataSource.addToCart(tRequestModel)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCartResponseNullCart),
        );

        final result = await repo.addToCart(tRequestModel);

        expect(result, isA<SuccessBaseResponse<CartEntity>>());
        expect((result as SuccessBaseResponse).data, tEmptyCartEntity);
        verify(mockDataSource.addToCart(tRequestModel)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test('returns ErrorBaseResponse when data source returns error', () async {
      when(
        mockDataSource.addToCart(tRequestModel),
      ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

      final result = await repo.addToCart(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CartEntity>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockDataSource.addToCart(tRequestModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('updateQuantity', () {
    test(
      'returns SuccessBaseResponse with CartEntity when cart is not null',
      () async {
        when(mockDataSource.updateQuantity(tRequestModel)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCartResponseWithData),
        );

        final result = await repo.updateQuantity(tRequestModel);

        expect(result, isA<SuccessBaseResponse<CartEntity>>());
        expect((result as SuccessBaseResponse).data, tCartEntity);
        verify(mockDataSource.updateQuantity(tRequestModel)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'returns SuccessBaseResponse with empty CartEntity when cart is null',
      () async {
        when(mockDataSource.updateQuantity(tRequestModel)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCartResponseNullCart),
        );

        final result = await repo.updateQuantity(tRequestModel);

        expect(result, isA<SuccessBaseResponse<CartEntity>>());
        expect((result as SuccessBaseResponse).data, tEmptyCartEntity);
        verify(mockDataSource.updateQuantity(tRequestModel)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test('returns ErrorBaseResponse when data source returns error', () async {
      when(
        mockDataSource.updateQuantity(tRequestModel),
      ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

      final result = await repo.updateQuantity(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CartEntity>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockDataSource.updateQuantity(tRequestModel)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });

  group('removeProductfromCart', () {
    test(
      'returns SuccessBaseResponse with CartEntity when cart is not null',
      () async {
        when(mockDataSource.removeProductfromCart(tProductId)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCartResponseWithData),
        );

        final result = await repo.removeProductfromCart(tProductId);

        expect(result, isA<SuccessBaseResponse<CartEntity>>());
        expect((result as SuccessBaseResponse).data, tCartEntity);
        verify(mockDataSource.removeProductfromCart(tProductId)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'returns SuccessBaseResponse with empty CartEntity when cart is null',
      () async {
        when(mockDataSource.removeProductfromCart(tProductId)).thenAnswer(
          (_) async => SuccessBaseResponse(data: tCartResponseNullCart),
        );

        final result = await repo.removeProductfromCart(tProductId);

        expect(result, isA<SuccessBaseResponse<CartEntity>>());
        expect((result as SuccessBaseResponse).data, tEmptyCartEntity);
        verify(mockDataSource.removeProductfromCart(tProductId)).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test('returns ErrorBaseResponse when data source returns error', () async {
      when(
        mockDataSource.removeProductfromCart(tProductId),
      ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

      final result = await repo.removeProductfromCart(tProductId);

      expect(result, isA<ErrorBaseResponse<CartEntity>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockDataSource.removeProductfromCart(tProductId)).called(1);
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}

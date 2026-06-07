import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/api/api_client/cart_api_client.dart';
import 'package:flower_app/features/cart/api/data_source_impl/cart_remote_data_source_impl.dart';
import 'package:flower_app/features/cart/data/models/cart_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([CartApiClient])
void main() {
  late MockCartApiClient mockCartApiClient;
  late CartRemoteDataSourceImpl dataSource;

  final tCartResponseModel = CartResponseModel();

  const tProductId = 'product_123';
  const tQuantity = 2;

  setUp(() {
    mockCartApiClient = MockCartApiClient();
    dataSource = CartRemoteDataSourceImpl(mockCartApiClient);
  });

  group('getCart', () {
    test('returns SuccessBaseResponse with CartResponseModel on success',
        () async {
      when(mockCartApiClient.getCart())
          .thenAnswer((_) async => tCartResponseModel);

      final result = await dataSource.getCart();

      expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
      expect((result as SuccessBaseResponse).data, tCartResponseModel);
      verify(mockCartApiClient.getCart()).called(1);
      verifyNoMoreInteractions(mockCartApiClient);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Network error');
      when(mockCartApiClient.getCart()).thenThrow(tException);

      final result = await dataSource.getCart();

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockCartApiClient.getCart()).called(1);
      verifyNoMoreInteractions(mockCartApiClient);
    });
  });

  group('addToCart', () {
    test('returns SuccessBaseResponse with CartResponseModel on success',
        () async {
      when(mockCartApiClient.addToCart(tProductId, tQuantity))
          .thenAnswer((_) async => tCartResponseModel);

      final result = await dataSource.addToCart(tProductId, tQuantity);

      expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
      expect((result as SuccessBaseResponse).data, tCartResponseModel);
      verify(mockCartApiClient.addToCart(tProductId, tQuantity)).called(1);
      verifyNoMoreInteractions(mockCartApiClient);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Add to cart failed');
      when(mockCartApiClient.addToCart(tProductId, tQuantity))
          .thenThrow(tException);

      final result = await dataSource.addToCart(tProductId, tQuantity);

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockCartApiClient.addToCart(tProductId, tQuantity)).called(1);
      verifyNoMoreInteractions(mockCartApiClient);
    });
  });

  group('updateQuantity', () {
    test('returns SuccessBaseResponse with CartResponseModel on success',
        () async {
      when(mockCartApiClient.updateQuantity(tProductId, tQuantity))
          .thenAnswer((_) async => tCartResponseModel);

      final result = await dataSource.updateQuantity(tProductId, tQuantity);

      expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
      expect((result as SuccessBaseResponse).data, tCartResponseModel);
      verify(mockCartApiClient.updateQuantity(tProductId, tQuantity)).called(1);
      verifyNoMoreInteractions(mockCartApiClient);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Update failed');
      when(mockCartApiClient.updateQuantity(tProductId, tQuantity))
          .thenThrow(tException);

      final result = await dataSource.updateQuantity(tProductId, tQuantity);

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockCartApiClient.updateQuantity(tProductId, tQuantity)).called(1);
      verifyNoMoreInteractions(mockCartApiClient);
    });
  });

  group('removeProductfromCart', () {
    test('returns SuccessBaseResponse with CartResponseModel on success',
        () async {
      when(mockCartApiClient.removeProductfromCart(tProductId))
          .thenAnswer((_) async => tCartResponseModel);

      final result = await dataSource.removeProductfromCart(tProductId);

      expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
      expect((result as SuccessBaseResponse).data, tCartResponseModel);
      verify(mockCartApiClient.removeProductfromCart(tProductId)).called(1);
      verifyNoMoreInteractions(mockCartApiClient);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Remove failed');
      when(mockCartApiClient.removeProductfromCart(tProductId))
          .thenThrow(tException);

      final result = await dataSource.removeProductfromCart(tProductId);

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockCartApiClient.removeProductfromCart(tProductId)).called(1);
      verifyNoMoreInteractions(mockCartApiClient);
    });
  });
}
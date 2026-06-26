import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/shopping/api/api_client/shopping_api_client.dart';
import 'package:flower_app/features/shopping/api/data_sources_impl/shopping_remote_data_source_impl.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/data/models/cart_response_model.dart';
import 'package:flower_app/features/shopping/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/shopping/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/shopping/data/models/orders_response.dart';
import 'package:flower_app/features/shopping/data/models/product_details_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'shopping_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ShoppingApiClient])
void main() {
  late MockShoppingApiClient mockShoppingApiClient;
  late ShoppingRemoteDataSourceImpl dataSource;

  setUp(() {
    mockShoppingApiClient = MockShoppingApiClient();
    dataSource = ShoppingRemoteDataSourceImpl(mockShoppingApiClient);
  });

  group('getCart', () {
    final tCartResponseModel = CartResponseModel();

    test(
      'returns SuccessBaseResponse with CartResponseModel on success',
      () async {
        when(
          mockShoppingApiClient.getCart(),
        ).thenAnswer((_) async => tCartResponseModel);

        final result = await dataSource.getCart();

        expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
        expect((result as SuccessBaseResponse).data, tCartResponseModel);
        verify(mockShoppingApiClient.getCart()).called(1);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Network error');
      when(mockShoppingApiClient.getCart()).thenThrow(tException);

      final result = await dataSource.getCart();

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockShoppingApiClient.getCart()).called(1);
    });
  });

  group('addToCart', () {
    final tCartResponseModel = CartResponseModel();
    const tRequestModel = CartRequestModel(
      productId: 'product_123',
      quantity: 2,
    );

    test(
      'returns SuccessBaseResponse with CartResponseModel on success',
      () async {
        when(
          mockShoppingApiClient.addToCart(
            tRequestModel.productId,
            tRequestModel.quantity,
          ),
        ).thenAnswer((_) async => tCartResponseModel);

        final result = await dataSource.addToCart(tRequestModel);

        expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
        expect((result as SuccessBaseResponse).data, tCartResponseModel);
        verify(
          mockShoppingApiClient.addToCart(
            tRequestModel.productId,
            tRequestModel.quantity,
          ),
        ).called(1);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Add to cart failed');
      when(
        mockShoppingApiClient.addToCart(
          tRequestModel.productId,
          tRequestModel.quantity,
        ),
      ).thenThrow(tException);

      final result = await dataSource.addToCart(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(
        mockShoppingApiClient.addToCart(
          tRequestModel.productId,
          tRequestModel.quantity,
        ),
      ).called(1);
    });
  });

  group('updateQuantity', () {
    final tCartResponseModel = CartResponseModel();
    const tRequestModel = CartRequestModel(
      productId: 'product_123',
      quantity: 2,
    );

    test(
      'returns SuccessBaseResponse with CartResponseModel on success',
      () async {
        when(
          mockShoppingApiClient.updateQuantity(
            tRequestModel.productId,
            tRequestModel.quantity,
          ),
        ).thenAnswer((_) async => tCartResponseModel);

        final result = await dataSource.updateQuantity(tRequestModel);

        expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
        expect((result as SuccessBaseResponse).data, tCartResponseModel);
        verify(
          mockShoppingApiClient.updateQuantity(
            tRequestModel.productId,
            tRequestModel.quantity,
          ),
        ).called(1);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Update failed');
      when(
        mockShoppingApiClient.updateQuantity(
          tRequestModel.productId,
          tRequestModel.quantity,
        ),
      ).thenThrow(tException);

      final result = await dataSource.updateQuantity(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(
        mockShoppingApiClient.updateQuantity(
          tRequestModel.productId,
          tRequestModel.quantity,
        ),
      ).called(1);
    });
  });

  group('removeProductfromCart', () {
    final tCartResponseModel = CartResponseModel();
    const tProductId = 'product_123';

    test(
      'returns SuccessBaseResponse with CartResponseModel on success',
      () async {
        when(
          mockShoppingApiClient.removeProductfromCart(tProductId),
        ).thenAnswer((_) async => tCartResponseModel);

        final result = await dataSource.removeProductfromCart(tProductId);

        expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
        expect((result as SuccessBaseResponse).data, tCartResponseModel);
        verify(
          mockShoppingApiClient.removeProductfromCart(tProductId),
        ).called(1);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Remove failed');
      when(
        mockShoppingApiClient.removeProductfromCart(tProductId),
      ).thenThrow(tException);

      final result = await dataSource.removeProductfromCart(tProductId);

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(
        mockShoppingApiClient.removeProductfromCart(tProductId),
      ).called(1);
    });
  });

  group('clearCart', () {
    final tCartResponseModel = CartResponseModel();

    test(
      'returns SuccessBaseResponse with CartResponseModel on success',
      () async {
        when(
          mockShoppingApiClient.clearCart(),
        ).thenAnswer((_) async => tCartResponseModel);

        final result = await dataSource.clearCart();

        expect(result, isA<SuccessBaseResponse<CartResponseModel>>());
        expect((result as SuccessBaseResponse).data, tCartResponseModel);
        verify(mockShoppingApiClient.clearCart()).called(1);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Clear cart failed');
      when(mockShoppingApiClient.clearCart()).thenThrow(tException);

      final result = await dataSource.clearCart();

      expect(result, isA<ErrorBaseResponse<CartResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockShoppingApiClient.clearCart()).called(1);
    });
  });

  group('getOrders', () {
    test('returns SuccessBaseResponse with OrdersResponse on success', () async {
      const response = OrdersResponse(message: 'Success');

      when(
        mockShoppingApiClient.getOrders(),
      ).thenAnswer((_) async => response);

      final result = await dataSource.getOrders();

      expect(result, isA<SuccessBaseResponse<OrdersResponse>>());
      expect((result as SuccessBaseResponse).data, response);
      verify(mockShoppingApiClient.getOrders()).called(1);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('network error');
      when(mockShoppingApiClient.getOrders()).thenThrow(tException);

      final result = await dataSource.getOrders();

      expect(result, isA<ErrorBaseResponse<OrdersResponse>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockShoppingApiClient.getOrders()).called(1);
    });
  });

  group('createCashOrder', () {
    const tRequestModel = PaymentRequestModel(
      street: 'Street 1',
      phone: '0102419753',
      city: 'Cairo',
      lat: '30.0',
      long: '31.0',
    );

    const tCashOrderResponseModel = CashOrderResponseModel(
      orderId: 'order_1',
      orderNumber: '1001',
      totalPrice: 100,
      state: 'pending',
    );

    test(
      'returns SuccessBaseResponse with CashOrderResponseModel on success',
      () async {
        when(
          mockShoppingApiClient.createCashOrder(tRequestModel.toJson()),
        ).thenAnswer((_) async => tCashOrderResponseModel);

        final result = await dataSource.createCashOrder(tRequestModel);

        expect(result, isA<SuccessBaseResponse<CashOrderResponseModel>>());
        expect((result as SuccessBaseResponse).data, tCashOrderResponseModel);
        verify(
          mockShoppingApiClient.createCashOrder(tRequestModel.toJson()),
        ).called(1);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Network error');
      when(
        mockShoppingApiClient.createCashOrder(tRequestModel.toJson()),
      ).thenThrow(tException);

      final result = await dataSource.createCashOrder(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CashOrderResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(
        mockShoppingApiClient.createCashOrder(tRequestModel.toJson()),
      ).called(1);
    });
  });

  group('createCheckoutSession', () {
    const tRequestModel = PaymentRequestModel(
      street: 'Street 1',
      phone: '0102419753',
      city: 'Cairo',
      lat: '30.0',
      long: '31.0',
    );

    const tCheckoutSessionResponseModel = CheckoutSessionResponseModel(
      sessionId: 'sess_1',
      sessionUrl: 'https://checkout.stripe.com/session',
    );

    test(
      'returns SuccessBaseResponse with CheckoutSessionResponseModel on success',
      () async {
        when(
          mockShoppingApiClient.createCheckoutSession(
            tRequestModel.toJson(),
            Endpoints.stripeRedirectUrl,
          ),
        ).thenAnswer((_) async => tCheckoutSessionResponseModel);

        final result = await dataSource.createCheckoutSession(tRequestModel);

        expect(
          result,
          isA<SuccessBaseResponse<CheckoutSessionResponseModel>>(),
        );
        expect(
          (result as SuccessBaseResponse).data,
          tCheckoutSessionResponseModel,
        );
        verify(
          mockShoppingApiClient.createCheckoutSession(
            tRequestModel.toJson(),
            Endpoints.stripeRedirectUrl,
          ),
        ).called(1);
      },
    );

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final tException = Exception('Network error');
      when(
        mockShoppingApiClient.createCheckoutSession(
          tRequestModel.toJson(),
          Endpoints.stripeRedirectUrl,
        ),
      ).thenThrow(tException);

      final result = await dataSource.createCheckoutSession(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CheckoutSessionResponseModel>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(
        mockShoppingApiClient.createCheckoutSession(
          tRequestModel.toJson(),
          Endpoints.stripeRedirectUrl,
        ),
      ).called(1);
    });
  });

  group('getProductDetails', () {
    const tProductId = '69d988754461df0f939b581a';

    final tProduct = Product(
      id: tProductId,
      title: 'Pink Rose Bouquet',
      description: 'Lorem ipsum',
      imgCover: 'https://example.com/cover.jpg',
      images: ['https://example.com/image.jpg'],
      price: 1500,
      priceAfterDiscount: 1200,
      quantity: 10,
      rateCount: 5,
      rateAvg: 4,
      isInWishlist: false,
    );

    final tResponse = ProductDetailsResponse(
      message: 'Success',
      products: [tProduct],
    );

    test('returns SuccessBaseResponse on success', () async {
      when(
        mockShoppingApiClient.getProductDetails(
          productId: anyNamed('productId'),
        ),
      ).thenAnswer((_) async => tResponse);

      final result = await dataSource.getProductDetails(
        productId: tProductId,
      );

      expect(result, isA<SuccessBaseResponse<ProductDetailsResponse>>());
      final success = result as SuccessBaseResponse<ProductDetailsResponse>;
      expect(success.data.products?.first.id, tProductId);
    });

    test('returns ErrorBaseResponse on exception', () async {
      when(
        mockShoppingApiClient.getProductDetails(
          productId: anyNamed('productId'),
        ),
      ).thenThrow(Exception('network error'));

      final result = await dataSource.getProductDetails(
        productId: tProductId,
      );

      expect(result, isA<ErrorBaseResponse<ProductDetailsResponse>>());
    });
  });
}

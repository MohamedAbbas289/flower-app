import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/data/data_sources_contract/shopping_remote_data_source_contract.dart';
import 'package:flower_app/features/shopping/data/models/cart_model.dart';
import 'package:flower_app/features/shopping/data/models/cart_response_model.dart';
import 'package:flower_app/features/shopping/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/shopping/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/shopping/data/models/order_model.dart';
import 'package:flower_app/features/shopping/data/models/orders_response.dart';
import 'package:flower_app/features/shopping/data/models/product_details_response.dart';
import 'package:flower_app/features/shopping/data/repository_impl/shopping_repository_impl.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'shopping_repository_impl_test.mocks.dart';

@GenerateMocks([ShoppingRemoteDataSourceContract])
void main() {
  late MockShoppingRemoteDataSourceContract mockDataSource;
  late ShoppingRepositoryImpl repo;

  setUpAll(() {
    provideDummy<BaseResponse<CartResponseModel>>(
      SuccessBaseResponse(data: const CartResponseModel(cart: null)),
    );
    provideDummy<OrdersResponse>(const OrdersResponse());
    provideDummy<BaseResponse<CashOrderResponseModel>>(
      SuccessBaseResponse(
        data: const CashOrderResponseModel(
          orderId: 'order_1',
          orderNumber: '1001',
          totalPrice: 100,
          state: 'pending',
        ),
      ),
    );
    provideDummy<BaseResponse<CheckoutSessionResponseModel>>(
      SuccessBaseResponse(
        data: const CheckoutSessionResponseModel(
          sessionId: 'sess_1',
          sessionUrl: 'https://checkout.stripe.com/session',
        ),
      ),
    );
    provideDummy<BaseResponse<ProductDetailsResponse>>(
      ErrorBaseResponse<ProductDetailsResponse>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockDataSource = MockShoppingRemoteDataSourceContract();
    repo = ShoppingRepositoryImpl(mockDataSource);
  });

  group('cart', () {
    const tRequestModel = CartRequestModel(
      productId: 'product_123',
      quantity: 2,
    );
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
      });
    });

    group('clearCart', () {
      test(
        'returns SuccessBaseResponse with empty CartEntity when cart is null',
        () async {
          when(mockDataSource.clearCart()).thenAnswer(
            (_) async => SuccessBaseResponse(data: tCartResponseNullCart),
          );

          final result = await repo.clearCart();

          expect(result, isA<SuccessBaseResponse<CartEntity>>());
          expect((result as SuccessBaseResponse).data, tEmptyCartEntity);
          verify(mockDataSource.clearCart()).called(1);
        },
      );

      test('returns ErrorBaseResponse when data source returns error', () async {
        when(
          mockDataSource.clearCart(),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

        final result = await repo.clearCart();

        expect(result, isA<ErrorBaseResponse<CartEntity>>());
        expect((result as ErrorBaseResponse).exception, tException);
        verify(mockDataSource.clearCart()).called(1);
      });
    });
  });

  group('getOrders', () {
    test(
      'returns SuccessBaseResponse<List<OrderEntity>> when datasource succeeds',
      () async {
        const orderModel = OrderModel(
          id: 'order1',
          orderNumber: '#123456',
          totalPrice: 600,
          isDelivered: false,
        );
        const response = OrdersResponse(orders: [orderModel]);

        when(mockDataSource.getOrders()).thenAnswer((_) async => response);

        final result = await repo.getOrders();

        expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
        final success = result as SuccessBaseResponse<List<OrderEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, 'order1');
        expect(success.data.first.orderNumber, '#123456');
        expect(success.data.first.totalPrice, 600);
        verify(mockDataSource.getOrders()).called(1);
      },
    );

    test(
      'returns SuccessBaseResponse with empty list when response has no orders',
      () async {
        const response = OrdersResponse(orders: []);

        when(mockDataSource.getOrders()).thenAnswer((_) async => response);

        final result = await repo.getOrders();

        expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
        final success = result as SuccessBaseResponse<List<OrderEntity>>;
        expect(success.data, isEmpty);
        verify(mockDataSource.getOrders()).called(1);
      },
    );

    test(
      'returns SuccessBaseResponse with empty list when orders field is null',
      () async {
        const response = OrdersResponse(orders: null);

        when(mockDataSource.getOrders()).thenAnswer((_) async => response);

        final result = await repo.getOrders();

        expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
        final success = result as SuccessBaseResponse<List<OrderEntity>>;
        expect(success.data, isEmpty);
        verify(mockDataSource.getOrders()).called(1);
      },
    );

    test(
      'returns ErrorBaseResponse<List<OrderEntity>> when datasource throws',
      () async {
        when(mockDataSource.getOrders()).thenThrow(Exception('Network error'));

        final result = await repo.getOrders();

        expect(result, isA<ErrorBaseResponse<List<OrderEntity>>>());
        verify(mockDataSource.getOrders()).called(1);
      },
    );
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

    const tCashOrderEntity = CashOrderEntity(
      id: 'order_1',
      orderNumber: '1001',
      totalPrice: 100,
      state: 'pending',
    );

    final tException = Exception('Something went wrong');

    test('returns SuccessBaseResponse with CashOrderEntity on success', () async {
      when(mockDataSource.createCashOrder(tRequestModel)).thenAnswer(
        (_) async => SuccessBaseResponse(data: tCashOrderResponseModel),
      );

      final result = await repo.createCashOrder(tRequestModel);

      expect(result, isA<SuccessBaseResponse<CashOrderEntity>>());
      expect((result as SuccessBaseResponse).data, tCashOrderEntity);
      verify(mockDataSource.createCashOrder(tRequestModel)).called(1);
    });

    test('returns ErrorBaseResponse when data source returns an error', () async {
      when(
        mockDataSource.createCashOrder(tRequestModel),
      ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

      final result = await repo.createCashOrder(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CashOrderEntity>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockDataSource.createCashOrder(tRequestModel)).called(1);
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

    const tCheckoutSessionEntity = CheckoutSessionEntity(
      sessionId: 'sess_1',
      sessionUrl: 'https://checkout.stripe.com/session',
    );

    final tException = Exception('Something went wrong');

    test('returns SuccessBaseResponse with CheckoutSessionEntity on success', () async {
      when(mockDataSource.createCheckoutSession(tRequestModel)).thenAnswer(
        (_) async => SuccessBaseResponse(data: tCheckoutSessionResponseModel),
      );

      final result = await repo.createCheckoutSession(tRequestModel);

      expect(result, isA<SuccessBaseResponse<CheckoutSessionEntity>>());
      expect((result as SuccessBaseResponse).data, tCheckoutSessionEntity);
      verify(mockDataSource.createCheckoutSession(tRequestModel)).called(1);
    });

    test('returns ErrorBaseResponse when data source returns an error', () async {
      when(
        mockDataSource.createCheckoutSession(tRequestModel),
      ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

      final result = await repo.createCheckoutSession(tRequestModel);

      expect(result, isA<ErrorBaseResponse<CheckoutSessionEntity>>());
      expect((result as ErrorBaseResponse).exception, tException);
      verify(mockDataSource.createCheckoutSession(tRequestModel)).called(1);
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

    test('returns SuccessBaseResponse with entity on success', () async {
      when(
        mockDataSource.getProductDetails(productId: anyNamed('productId')),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tResponse));

      final result = await repo.getProductDetails(productId: tProductId);

      expect(result, isA<SuccessBaseResponse<ProductDetailsEntity>>());
      final success = result as SuccessBaseResponse<ProductDetailsEntity>;
      expect(success.data.id, tProductId);
      expect(success.data.price, 1500);
    });

    test('returns ErrorBaseResponse on failure', () async {
      when(
        mockDataSource.getProductDetails(productId: anyNamed('productId')),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('network error')),
      );

      final result = await repo.getProductDetails(productId: tProductId);

      expect(result, isA<ErrorBaseResponse<ProductDetailsEntity>>());
    });
  });
}

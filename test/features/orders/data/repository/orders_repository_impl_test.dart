import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/orders/api/responses/orders_response.dart';
import 'package:flower_app/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:flower_app/features/orders/data/models/order_model.dart';
import 'package:flower_app/features/orders/data/repository/orders_repository_impl.dart';
import 'package:flower_app/features/orders/domain/entities/order_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'orders_repository_impl_test.mocks.dart';

@GenerateMocks([OrdersRemoteDataSource])
void main() {
  late MockOrdersRemoteDataSource mockDataSource;
  late OrdersRepositoryImpl repository;

  setUpAll(() {
    provideDummy<OrdersResponse>(const OrdersResponse());
  });

  setUp(() {
    mockDataSource = MockOrdersRemoteDataSource();
    repository = OrdersRepositoryImpl(mockDataSource);
  });

  group('OrdersRepositoryImpl', () {
    test(
      'getOrders returns SuccessBaseResponse<List<OrderEntity>> when datasource succeeds',
      () async {
        const orderModel = OrderModel(
          id: 'order1',
          orderNumber: '#123456',
          totalPrice: 600,
          isDelivered: false,
        );
        const response = OrdersResponse(orders: [orderModel]);

        when(mockDataSource.getOrders()).thenAnswer((_) async => response);

        final result = await repository.getOrders();

        expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
        final success = result as SuccessBaseResponse<List<OrderEntity>>;
        expect(success.data.length, 1);
        expect(success.data.first.id, 'order1');
        expect(success.data.first.orderNumber, '#123456');
        expect(success.data.first.totalPrice, 600);
        verify(mockDataSource.getOrders()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'getOrders returns SuccessBaseResponse with empty list when response has no orders',
      () async {
        const response = OrdersResponse(orders: []);

        when(mockDataSource.getOrders()).thenAnswer((_) async => response);

        final result = await repository.getOrders();

        expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
        final success = result as SuccessBaseResponse<List<OrderEntity>>;
        expect(success.data, isEmpty);
        verify(mockDataSource.getOrders()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'getOrders returns SuccessBaseResponse with empty list when orders field is null',
      () async {
        const response = OrdersResponse(orders: null);

        when(mockDataSource.getOrders()).thenAnswer((_) async => response);

        final result = await repository.getOrders();

        expect(result, isA<SuccessBaseResponse<List<OrderEntity>>>());
        final success = result as SuccessBaseResponse<List<OrderEntity>>;
        expect(success.data, isEmpty);
        verify(mockDataSource.getOrders()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'getOrders returns ErrorBaseResponse<List<OrderEntity>> when datasource throws',
      () async {
        when(mockDataSource.getOrders()).thenThrow(Exception('Network error'));

        final result = await repository.getOrders();

        expect(result, isA<ErrorBaseResponse<List<OrderEntity>>>());
        verify(mockDataSource.getOrders()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );
  });
}

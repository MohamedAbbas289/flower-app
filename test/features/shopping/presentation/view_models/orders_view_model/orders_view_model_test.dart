import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/order_status.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';
import 'package:flower_app/features/shopping/domain/use_cases/get_orders_use_case.dart';
import 'package:flower_app/features/shopping/presentation/view_models/orders_view_model/orders_state.dart';
import 'package:flower_app/features/shopping/presentation/view_models/orders_view_model/orders_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'orders_view_model_test.mocks.dart';

const _tActiveOrder = OrderEntity(
  id: 'order1',
  orderNumber: '#111',
  totalPrice: 300,
  isDelivered: false,
  state: OrderStatus.accepted,
);

const _tCompletedOrder = OrderEntity(
  id: 'order2',
  orderNumber: '#222',
  totalPrice: 600,
  isDelivered: true,
  state: OrderStatus.delivered,
);

const _tCanceledOrder = OrderEntity(
  id: 'order3',
  orderNumber: '#333',
  totalPrice: 150,
  isDelivered: false,
  state: OrderStatus.canceled,
);

@GenerateMocks([GetOrdersUseCase])
void main() {
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late OrdersViewModel viewModel;

  setUpAll(() {
    provideDummy<BaseResponse<List<OrderEntity>>>(
      SuccessBaseResponse<List<OrderEntity>>(data: const []),
    );
  });

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    when(
      mockGetOrdersUseCase.execute(),
    ).thenAnswer((_) async => SuccessBaseResponse(data: const []));
    viewModel = OrdersViewModel(mockGetOrdersUseCase);
  });

  tearDown(() => viewModel.close());

  group('OrdersViewModel', () {
    test(
      'state after construction has ordersState with data',
      () async {
        await Future.delayed(Duration.zero);
        expect(viewModel.state.ordersState.isLoading, isFalse);
        expect(viewModel.state.ordersState.data, equals(const <OrderEntity>[]));
        expect(viewModel.state.ordersState.msg, isNull);
      },
    );

    blocTest<OrdersViewModel, OrdersState>(
      'constructor triggers GetOrdersEvent — state settles with fetched orders',
      build: () {
        when(mockGetOrdersUseCase.execute()).thenAnswer(
          (_) async => SuccessBaseResponse(
            data: const [_tActiveOrder, _tCompletedOrder, _tCanceledOrder],
          ),
        );
        return OrdersViewModel(mockGetOrdersUseCase);
      },
      expect: () => [
        isA<OrdersState>().having(
          (s) => s.ordersState.data,
          'orders loaded',
          containsAll([_tActiveOrder, _tCompletedOrder, _tCanceledOrder]),
        ),
      ],
    );

    blocTest<OrdersViewModel, OrdersState>(
      'constructor triggers GetOrdersEvent — state settles with error when use case fails',
      build: () {
        when(mockGetOrdersUseCase.execute()).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('Server error')),
        );
        return OrdersViewModel(mockGetOrdersUseCase);
      },
      expect: () => [
        isA<OrdersState>().having(
          (s) => s.ordersState.msg,
          'error message present',
          isNotNull,
        ),
      ],
    );

    test('activeOrders getter returns only active non-canceled orders', () async {
      when(mockGetOrdersUseCase.execute()).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const [_tActiveOrder, _tCompletedOrder, _tCanceledOrder],
        ),
      );
      final vm = OrdersViewModel(mockGetOrdersUseCase);
      await Future.delayed(Duration.zero);

      expect(vm.activeOrders, hasLength(1));
      expect(vm.activeOrders.first.id, 'order1');
      await vm.close();
    });

    test('completedOrders getter returns delivered and canceled orders', () async {
      when(mockGetOrdersUseCase.execute()).thenAnswer(
        (_) async => SuccessBaseResponse(
          data: const [_tActiveOrder, _tCompletedOrder, _tCanceledOrder],
        ),
      );
      final vm = OrdersViewModel(mockGetOrdersUseCase);
      await Future.delayed(Duration.zero);

      expect(vm.completedOrders, hasLength(2));
      expect(vm.completedOrders.map((o) => o.id), containsAll(['order2', 'order3']));
      await vm.close();
    });

    test(
      'activeOrders and completedOrders are empty when state has no data',
      () {
        expect(viewModel.activeOrders, isEmpty);
        expect(viewModel.completedOrders, isEmpty);
      },
    );
  });
}

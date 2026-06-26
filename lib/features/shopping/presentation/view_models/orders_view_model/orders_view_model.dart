import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';
import 'package:flower_app/features/shopping/domain/use_cases/get_orders_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'orders_events.dart';
import 'orders_state.dart';

@injectable
class OrdersViewModel extends Cubit<OrdersState> {
  OrdersViewModel(this._getOrdersUseCase) : super(const OrdersState()) {
    doEvent(GetOrdersEvent());
  }

  final GetOrdersUseCase _getOrdersUseCase;

  void doEvent(OrdersEvents event) {
    switch (event) {
      case GetOrdersEvent():
        _fetchOrders();
    }
  }

  List<OrderEntity> get activeOrders => (state.ordersState.data ?? [])
      .where((order) => order.isDelivered == false)
      .toList();

  List<OrderEntity> get completedOrders => (state.ordersState.data ?? [])
      .where((order) => order.isDelivered == true)
      .toList();

  Future<void> _fetchOrders() async {
    emit(state.copyWith(ordersState: BaseState.loading()));
    final response = await _getOrdersUseCase.execute();
    switch (response) {
      case SuccessBaseResponse<List<OrderEntity>>():
        emit(state.copyWith(ordersState: BaseState.success(response.data)));
      case ErrorBaseResponse<List<OrderEntity>>():
        emit(
          state.copyWith(ordersState: BaseState.error(response.errorMessage)),
        );
    }
  }
}

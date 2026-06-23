import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';

class OrdersState extends Equatable {
  final BaseState<List<OrderEntity>> ordersState;

  const OrdersState({this.ordersState = const BaseState()});

  OrdersState copyWith({BaseState<List<OrderEntity>>? ordersState}) {
    return OrdersState(ordersState: ordersState ?? this.ordersState);
  }

  @override
  List<Object?> get props => [ordersState];
}

import 'package:equatable/equatable.dart';

class CashOrderEntity extends Equatable {
  final String? id;
  final String? orderNumber;
  final int? totalPrice;
  final String? state;

  const CashOrderEntity({this.id, this.orderNumber, this.totalPrice, this.state});

  @override
  List<Object?> get props => [id, orderNumber, totalPrice, state];
}

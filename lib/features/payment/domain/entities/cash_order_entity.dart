import 'package:equatable/equatable.dart';

class CashOrderEntity extends Equatable {
  final String id;
  final String userId;
  final double totalPrice;
  final String message;

  const CashOrderEntity({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.message,
  });

  @override
  List<Object?> get props => [id, userId, totalPrice, message];
}

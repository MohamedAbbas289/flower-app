import 'package:equatable/equatable.dart';

class CheckoutSessionEntity extends Equatable {
  final String status;
  final String sessionUrl;

  const CheckoutSessionEntity({required this.status, required this.sessionUrl});

  @override
  List<Object?> get props => [status, sessionUrl];
}

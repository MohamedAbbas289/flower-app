import 'package:equatable/equatable.dart';

class CheckoutSessionEntity extends Equatable {
  final String? sessionId;
  final String? sessionUrl;

  const CheckoutSessionEntity({this.sessionId, this.sessionUrl});

  @override
  List<Object?> get props => [sessionId, sessionUrl];
}

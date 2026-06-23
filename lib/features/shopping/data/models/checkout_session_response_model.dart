import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';

class CheckoutSessionResponseModel {
  final String? message;
  final String? sessionId;
  final String? sessionUrl;

  const CheckoutSessionResponseModel({
    this.message,
    this.sessionId,
    this.sessionUrl,
  });

  factory CheckoutSessionResponseModel.fromJson(Map<String, dynamic> json) {
    final session = json['session'] as Map<String, dynamic>?;
    return CheckoutSessionResponseModel(
      message: json['message'] as String?,
      sessionId: session?['id'] as String?,
      sessionUrl: session?['url'] as String?,
    );
  }

  CheckoutSessionEntity toEntity() =>
      CheckoutSessionEntity(sessionId: sessionId, sessionUrl: sessionUrl);
}

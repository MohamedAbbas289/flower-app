import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';

class CheckoutSessionResponseModel {
  final String? status;
  final String? sessionUrl;

  const CheckoutSessionResponseModel({this.status, this.sessionUrl});

  factory CheckoutSessionResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionResponseModel(
      status: json['status'] as String?,
      sessionUrl: json['session'] != null
          ? json['session']['url'] as String?
          : null,
    );
  }
}

extension CheckoutSessionMapper on CheckoutSessionResponseModel {
  CheckoutSessionEntity toEntity() {
    return CheckoutSessionEntity(
      status: status ?? '',
      sessionUrl: sessionUrl ?? '',
    );
  }
}

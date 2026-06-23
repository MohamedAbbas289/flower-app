import 'package:flower_app/features/shopping/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/shopping/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/shopping/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/checkout_session_entity.dart';

extension CashOrderResponseModelMapper on CashOrderResponseModel {
  CashOrderEntity toEntity() => CashOrderEntity(
    id: orderId,
    orderNumber: orderNumber,
    totalPrice: totalPrice,
    state: state,
  );
}

extension CheckoutSessionResponseModelMapper on CheckoutSessionResponseModel {
  CheckoutSessionEntity toEntity() =>
      CheckoutSessionEntity(sessionId: sessionId, sessionUrl: sessionUrl);
}

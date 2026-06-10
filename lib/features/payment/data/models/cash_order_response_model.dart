import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';

class CashOrderResponseModel {
  final String? message;
  final CashOrderDataModel? order;

  const CashOrderResponseModel({this.message, this.order});

  factory CashOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CashOrderResponseModel(
      message: json['message'] as String?,
      order: json['order'] != null
          ? CashOrderDataModel.fromJson(json['order'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CashOrderDataModel {
  final String? user;
  final String? id;
  final double? totalOrderPrice;

  const CashOrderDataModel({this.user, this.id, this.totalOrderPrice});

  factory CashOrderDataModel.fromJson(Map<String, dynamic> json) {
    return CashOrderDataModel(
      user: json['user'] as String?,
      id: json['_id'] as String?,
      totalOrderPrice: (json['totalOrderPrice'] as num?)?.toDouble(),
    );
  }
}

extension CashOrderResponseMapper on CashOrderResponseModel {
  CashOrderEntity toEntity() {
    return CashOrderEntity(
      id: order?.id ?? '',
      userId: order?.user ?? '',
      totalPrice: order?.totalOrderPrice ?? 0.0,
      message: message ?? '',
    );
  }
}

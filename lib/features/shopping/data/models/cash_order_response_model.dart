class CashOrderResponseModel {
  final String? message;
  final String? orderId;
  final String? orderNumber;
  final int? totalPrice;
  final String? state;

  const CashOrderResponseModel({
    this.message,
    this.orderId,
    this.orderNumber,
    this.totalPrice,
    this.state,
  });

  factory CashOrderResponseModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'] as Map<String, dynamic>?;
    return CashOrderResponseModel(
      message: json['message'] as String?,
      orderId: order?['_id'] as String?,
      orderNumber: order?['orderNumber'] as String?,
      totalPrice: order?['totalPrice'] as int?,
      state: order?['state'] as String?,
    );
  }
}

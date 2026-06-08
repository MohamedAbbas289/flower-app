import 'package:flower_app/core/values/api_param.dart';

class CartRequestModel {
    final String productId;
    final int quantity;

  const CartRequestModel({
    required this.productId,
    required this.quantity,
  });
  Map<String, dynamic> toJson() {
    return {
      ApiParam.productId: productId,
      ApiParam.quantity: quantity,
    };
  }
}

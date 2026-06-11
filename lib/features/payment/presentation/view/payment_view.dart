import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/presentation/view/payment_view_body.dart';
import 'package:flutter/material.dart';

// BlocProvider is provided at route level in app_routes.dart
class PaymentView extends StatelessWidget {
  final PaymentRequestModel requestModel;
  final double subTotal;
  final double deliveryFee;
  final double total;

  const PaymentView({
    super.key,
    required this.requestModel,
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.payment,
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: PaymentViewBody(
          requestModel: requestModel,
          subTotal: subTotal,
          deliveryFee: deliveryFee,
          total: total,
        ),
      ),
    );
  }
}

import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class PaymentStepHeader extends StatelessWidget {
  final int currentStep;

  PaymentStepHeader({super.key, required this.currentStep})
    : assert(
        currentStep >= 1 && currentStep <= 3,
        AppStrings.stepMustBeBetween1And3,
      );
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(number: '1', label: AppStrings.address, stepIndex: 1),
        _buildLine(lineIndex: 1),
        _buildStep(number: '2', label: AppStrings.payment, stepIndex: 2),
        _buildLine(lineIndex: 2),
        _buildStep(number: '3', label: AppStrings.trackOrder, stepIndex: 3),
      ],
    );
  }

  Widget _buildStep({
    required String number,
    required String label,
    required int stepIndex,
  }) {
    final bool isActive = currentStep == stepIndex;
    final bool isCompleted = currentStep > stepIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.pink : AppColors.white,
            border: Border.all(
              color: (isActive || isCompleted)
                  ? AppColors.pink
                  : AppColors.gray.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyles.bodyRegular14.copyWith(
                color: isActive
                    ? AppColors.white
                    : (isCompleted ? AppColors.pink : AppColors.gray),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyles.bodyRegular12.copyWith(
            color: (isActive || isCompleted) ? AppColors.black : AppColors.gray,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildLine({required int lineIndex}) {
    final bool isLineCompleted = currentStep > lineIndex;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 2,
        color: isLineCompleted
            ? AppColors.pink
            : AppColors.gray.withOpacity(0.3),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class GenderOption extends StatelessWidget {
  final String gender;
  final String value;
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const GenderOption({
    super.key,
    required this.gender,
    required this.value,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      groupValue: selectedGender,

      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },

      child: RadioListTile<String>(
        value: value,

        fillColor: WidgetStateProperty.all(AppColors.pink),

        title: Text(gender, style: TextStyles.bodyRegular14),
      ),
    );
  }
}

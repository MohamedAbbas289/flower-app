import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  late String _selectedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLanguage = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: RadioGroup<String>(
        groupValue: _selectedLanguage,
        onChanged: (v) {
          setState(() => _selectedLanguage = v!);
          context.setLocale(Locale(v!));
          Navigator.pop(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.changeLanguage,
              style: TextStyles.bodyRegular18.copyWith(color: AppColors.pink),
            ),
            const SizedBox(height: 16),
            _buildLanguageOption(label: AppStrings.arabic, value: 'ar'),
            const Divider(color: AppColors.gray, height: 1),
            _buildLanguageOption(label: AppStrings.english, value: 'en'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String label,
    required String value,
  }) {
    return InkWell(
      onTap: () {
        setState(() => _selectedLanguage = value);
        context.setLocale(Locale(value));
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyles.bodyRegular14),
            Radio<String>(value: value, activeColor: AppColors.pink),
          ],
        ),
      ),
    );
  }
}
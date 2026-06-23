import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/home/presentation/view_models/categories_view_model/categories_events.dart';
import 'package:flower_app/features/home/presentation/view_models/categories_view_model/categories_states.dart';
import 'package:flower_app/features/home/presentation/view_models/categories_view_model/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesFilterBottomSheet extends StatefulWidget {
  const CategoriesFilterBottomSheet({super.key});

  @override
  State<CategoriesFilterBottomSheet> createState() =>
      _CategoriesFilterBottomSheetState();
}

class _CategoriesFilterBottomSheetState
    extends State<CategoriesFilterBottomSheet> {
  SortType? _selectedSortType;

  @override
  void initState() {
    super.initState();
    _selectedSortType =
        context
            .read<CategoriesViewModel>()
            .state
            .selectedSortType;
  }

  void _apply() {
    if (_selectedSortType != null) {
      context
          .read<CategoriesViewModel>()
          .doEvent(SortSelectedEvent(_selectedSortType!));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesViewModel, CategoriesState>(
      buildWhen: (prev, curr) =>
      prev.selectedSortType != curr.selectedSortType,
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.placeHolder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.sortBy,
                style:
                TextStyles.appBarTextStyle.copyWith(color: AppColors.pink),
              ),
              const SizedBox(height: 16),
              _buildOption(AppStrings.lowestPrice, SortType.lowestPrice),
              _buildOption(AppStrings.highestPrice, SortType.highestPrice),
              _buildOption(AppStrings.newSort, SortType.newest),
              _buildOption(AppStrings.oldSort, SortType.oldest),
              _buildOption(AppStrings.discount, SortType.discount),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _apply,
                child: Text(AppStrings.filter),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(String title, SortType value) {
    return InkWell(
      onTap: () => setState(() => _selectedSortType = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyles.bodyRegular16),
            RadioGroup<SortType>(
              groupValue: _selectedSortType,
              onChanged: (v) => setState(() => _selectedSortType = v),
              child: Radio<SortType>(value: value, activeColor: AppColors.pink),
            ),
          ],
        ),
      ),
    );
  }
}

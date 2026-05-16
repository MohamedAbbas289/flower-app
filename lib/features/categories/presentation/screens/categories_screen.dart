import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/features/categories/presentation/view/categories_view.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_events.dart';
import 'package:flower_app/features/categories/presentation/view_model/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, this.initialCategoryId});

  final String? initialCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoriesViewModel>()
        ..doEvent(LoadInitialDataEvent(initialCategoryId: initialCategoryId)),
      child: const CategoriesView(),
    );
  }
}

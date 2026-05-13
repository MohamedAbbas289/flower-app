
import 'package:flower_app/features/home_screen/domain/entities/best_seller_model.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_model.dart';

import '../../../domain/entities/category_model.dart';


class HomeState {

  final bool categoriesLoading;
  final bool occasionsLoading;
  final bool bestSellersLoading;
  final List<CategoryModel> categories;
  final List<OccasionModel> occasions;
  final List<BestSellerModel> bestSellers;
  final String categoriesError;
  final String occasionsError;
  final String bestSellersError;

  const HomeState({
    this.categoriesLoading = false,
    this.occasionsLoading = false,
    this.bestSellersLoading = false,
    this.categories = const [],
    this.occasions = const [],
    this.bestSellers = const [],
    this.categoriesError = '',
    this.occasionsError = '',
    this.bestSellersError = '',
  });

  HomeState copyWith({
    bool? categoriesLoading,
    bool? occasionsLoading,
    bool? bestSellersLoading,
    List<CategoryModel>? categories,
    List<OccasionModel>? occasions,
    List<BestSellerModel>? bestSellers,
    String? categoriesError,
    String? occasionsError,
    String? bestSellersError,
  }) {
    return HomeState(
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      occasionsLoading: occasionsLoading ?? this.occasionsLoading,
      bestSellersLoading: bestSellersLoading ?? this.bestSellersLoading,
      categories: categories ?? this.categories,
      occasions: occasions ?? this.occasions,
      bestSellers: bestSellers ?? this.bestSellers,
      categoriesError: categoriesError ?? this.categoriesError,
      occasionsError: occasionsError ?? this.occasionsError,
      bestSellersError: bestSellersError ?? this.bestSellersError,
    );
  }
}

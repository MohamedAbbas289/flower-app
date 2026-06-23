import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/home/domain/entities/home_best_seller_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_category_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_occasion_entity.dart';

class HomeState extends Equatable {
  final BaseState<List<HomeCategoryEntity>> categoriesState;
  final BaseState<List<BestSellerEntity>> bestSellersState;
  final BaseState<List<HomeOccasionEntity>> occasionsState;

  const HomeState({
    this.categoriesState = const BaseState(),
    this.bestSellersState = const BaseState(),
    this.occasionsState = const BaseState(),
  });

  HomeState copyWith({
    BaseState<List<HomeCategoryEntity>>? categoriesState,
    BaseState<List<BestSellerEntity>>? bestSellersState,
    BaseState<List<HomeOccasionEntity>>? occasionsState,
  }) {
    return HomeState(
      categoriesState: categoriesState ?? this.categoriesState,
      bestSellersState: bestSellersState ?? this.bestSellersState,
      occasionsState: occasionsState ?? this.occasionsState,
    );
  }

  @override
  List<Object?> get props => [
    categoriesState,
    bestSellersState,
    occasionsState,
  ];
}

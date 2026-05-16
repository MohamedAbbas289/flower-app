import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_entity.dart';

import '../../../domain/entities/category_entity.dart';

class HomeState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<List<OccasionEntity>> occasionsState;
  final BaseState<List<BestSellerEntity>> bestSellersState;

  const HomeState({
    this.categoriesState = const BaseState(),
    this.occasionsState = const BaseState(),
    this.bestSellersState = const BaseState(),
  });

  HomeState copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<List<OccasionEntity>>? occasionsState,
    BaseState<List<BestSellerEntity>>? bestSellersState,
  }) {
    return HomeState(
      categoriesState: categoriesState ?? this.categoriesState,
      occasionsState: occasionsState ?? this.occasionsState,
      bestSellersState: bestSellersState ?? this.bestSellersState,
    );
  }

  @override
  List<Object?> get props => [
    categoriesState,
    occasionsState,
    bestSellersState,
  ];
}

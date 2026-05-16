import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_entity.dart';

class HomeState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<List<BestSellerEntity>> bestSellersState;
  final BaseState<List<OccasionEntity>> occasionsState;

  const HomeState({
    this.categoriesState = const BaseState(),
    this.bestSellersState = const BaseState(),
    this.occasionsState = const BaseState(),
  });

  HomeState copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<List<BestSellerEntity>>? bestSellersState,
    BaseState<List<OccasionEntity>>? occasionsState,
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

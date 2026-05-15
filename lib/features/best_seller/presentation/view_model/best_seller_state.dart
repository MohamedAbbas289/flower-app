import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/best_seller/domain/entity/best_seller_product_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class BestSellerState extends Equatable {
  final BaseState<List<BestSellerProductEntity>> bestSellerState;

  const BestSellerState({this.bestSellerState = const BaseState()});
  BestSellerState copyWith({
    BaseState<List<BestSellerProductEntity>>? bestSellerState,
  }) {
    return BestSellerState(
      bestSellerState: bestSellerState ?? this.bestSellerState,
    );
  }

  @override
  List<Object?> get props => [bestSellerState];
}

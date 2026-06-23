import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/home/domain/entities/product_entity.dart';

class SearchState extends Equatable {
  final BaseState<List<ProductEntity>> productsState;
  final bool isInitial;

  const SearchState({
    this.productsState = const BaseState(),
    this.isInitial = true,
  });

  SearchState copyWith({
    BaseState<List<ProductEntity>>? productsState,
    bool? isInitial,
  }) {
    return SearchState(
      productsState: productsState ?? this.productsState,
      isInitial: isInitial ?? this.isInitial,
    );
  }

  @override
  List<Object?> get props => [productsState, isInitial];
}

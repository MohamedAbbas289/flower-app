import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';

class ProductDetailsBaseState extends Equatable {
  final BaseState<ProductDetailsEntity> productDetailsState;

  const ProductDetailsBaseState({this.productDetailsState = const BaseState()});

  ProductDetailsBaseState copyWith({
    BaseState<ProductDetailsEntity>? productDetailsState,
  }) {
    return ProductDetailsBaseState(
      productDetailsState: productDetailsState ?? this.productDetailsState,
    );
  }

  @override
  List<Object> get props => [productDetailsState];
}

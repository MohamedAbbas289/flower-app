import 'package:equatable/equatable.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';

abstract class ProductDetailsBaseState extends Equatable {
  const ProductDetailsBaseState();

  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsBaseState {
  const ProductDetailsInitial();
}

class ProductDetailsLoading extends ProductDetailsBaseState {
  const ProductDetailsLoading();
}

class ProductDetailsSuccess extends ProductDetailsBaseState {
  final ProductDetailsEntity entity;
  const ProductDetailsSuccess(this.entity);

  @override
  List<Object?> get props => [entity];
}

class ProductDetailsFailure extends ProductDetailsBaseState {
  final String error;
  const ProductDetailsFailure(this.error);

  @override
  List<Object?> get props => [error];
}

import 'package:equatable/equatable.dart';
import 'package:flower_app/core/entities/metadata_entity.dart';
import 'package:flower_app/features/home/domain/entities/product_entity.dart';

class ProductsResponseEntity extends Equatable {
  final List<ProductEntity> products;
  final MetadataEntity? metadata;

  const ProductsResponseEntity({required this.products, this.metadata});

  @override
  List<Object?> get props => [products, metadata];
}

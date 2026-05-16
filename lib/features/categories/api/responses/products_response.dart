import 'package:flower_app/core/models/metadata_model.dart';
import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response.g.dart';

@JsonSerializable()
class ProductsResponse {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'metadata')
  final MetadataModel? metadata;

  @JsonKey(name: 'products')
  final List<ProductModel>? products;

  const ProductsResponse({this.message, this.metadata, this.products});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);

  ProductsResponseEntity toEntity() {
    return ProductsResponseEntity(
      products: products?.map((e) => e.toEntity()).toList() ?? [],
      metadata: metadata?.toEntity(),
    );
  }
}

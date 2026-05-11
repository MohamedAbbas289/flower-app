import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response.g.dart';

@JsonSerializable()
class ProductsResponse {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'products')
  final List<ProductModel>? products;

  const ProductsResponse({this.message, this.products});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);
}

import 'package:flower_app/features/best_seller/data/model/best_seller_product_model_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'best_seller_response.g.dart';

@JsonSerializable()
class BestSellerResponse
 {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "bestSeller")
  List<BestSellerProductModelDTO>? bestSeller;

  BestSellerResponse({this.message, this.bestSeller});

  factory BestSellerResponse.fromJson(Map<String, dynamic> json) =>
      _$BestSellerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BestSellerResponseToJson(this);
}

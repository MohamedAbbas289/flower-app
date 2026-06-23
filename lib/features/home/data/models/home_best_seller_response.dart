import 'package:json_annotation/json_annotation.dart';

import 'home_best_seller_dto.dart';
part 'home_best_seller_response.g.dart';

@JsonSerializable()
class HomeBestSellerResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "bestSeller")
  List<BestSellerDto>? bestSeller;

  HomeBestSellerResponse({
    this.message,
    this.bestSeller,
  });

  factory HomeBestSellerResponse.fromJson(Map<String, dynamic> json) => _$HomeBestSellerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBestSellerResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

import 'best_seller.dart';
part 'best_seller_response.g.dart';

@JsonSerializable()
class BestSellerResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "bestSeller")
  List<BestSellerDto>? bestSeller;

  BestSellerResponse({
    this.message,
    this.bestSeller,
  });

  factory BestSellerResponse.fromJson(Map<String, dynamic> json) => _$BestSellerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BestSellerResponseToJson(this);
}

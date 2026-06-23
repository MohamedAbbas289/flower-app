import 'package:equatable/equatable.dart';

class BestSellerEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? imgCover;
  final int? price;
  final int? priceAfterDiscount;
  final int? discount;
  final int? sold;
  final int? quantity;
  final String? category;
  final String? occasion;
  final String? bestSellerId;

  const BestSellerEntity({
    this.id,
    this.title,
    this.description,
    this.imgCover,
    this.price,
    this.priceAfterDiscount,
    this.discount,
    this.sold,
    this.quantity,
    this.category,
    this.occasion,
    this.bestSellerId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imgCover,
    price,
    priceAfterDiscount,
    discount,
    sold,
    quantity,
    category,
    occasion,
    bestSellerId,
  ];
}

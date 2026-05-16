import 'package:equatable/equatable.dart';

class BestSellerEntity extends Equatable {
  final String? id;
  final String? title;
  final String? slug;
  final String? description;
  final String? imgCover;
  final List<String>? images;
  final int? price;
  final int? priceAfterDiscount;
  final int? discount;
  final int? rateAvg;
  final int? rateCount;
  final int? sold;
  final int? quantity;
  final String? category;
  final String? occasion;
  final bool? isSuperAdmin;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? bestSellerId;

  const BestSellerEntity({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.discount,
    this.rateAvg,
    this.rateCount,
    this.sold,
    this.quantity,
    this.category,
    this.occasion,
    this.isSuperAdmin,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.bestSellerId,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    slug,
    description,
    imgCover,
    images,
    price,
    priceAfterDiscount,
    discount,
    rateAvg,
    rateCount,
    sold,
    quantity,
    category,
    occasion,
    isSuperAdmin,
    createdAt,
    updatedAt,
    v,
    bestSellerId,
  ];
}

import 'package:equatable/equatable.dart';

class ProductDetailsEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imgCover;
  final List<String> images;
  final int price;
  final int priceAfterDiscount;
  final int quantity;
  final int rateCount;
  final double rateAvg;
  final bool isInWishlist;

  const ProductDetailsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imgCover,
    required this.images,
    required this.price,
    required this.priceAfterDiscount,
    required this.quantity,
    required this.rateCount,
    required this.rateAvg,
    required this.isInWishlist,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imgCover,
    images,
    price,
    priceAfterDiscount,
    quantity,
    rateCount,
    rateAvg,
    isInWishlist,
  ];
}

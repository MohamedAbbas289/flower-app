import 'package:equatable/equatable.dart';
import 'package:flower_app/core/entities/product_card_data.dart';

class BestSellerProductEntity extends Equatable implements ProductCardData {
  final String? title;
  final String? slug;
  final String? description;
  final String? imgCover;
  final List<String>? images;
  final int? productPrice;
  final int? priceAfterDiscount;
  final int? discount;
  final int? sold;
  final int? quantity;
  final String? productId;

  const BestSellerProductEntity({
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.productPrice,
    this.priceAfterDiscount,
    this.discount,
    this.sold,
    this.quantity,
    this.productId,
  });
  @override
  int? get discountPercent => discount;

  @override
  String get id => productId ?? '';

  @override
  String get imageUrl => imgCover ?? '';

  @override
  String get name => title ?? '';

  @override
  int? get originalPrice => productPrice;

  @override
  int get price => productPrice ?? 0;

  @override
  List<Object?> get props => [
    title,
    slug,
    description,
    imgCover,
    images,
    productPrice,
    priceAfterDiscount,
    discount,
    sold,
    quantity,
    productId,
  ];

  // copyWith method to create a new instance with modified fields
  BestSellerProductEntity copyWith({
    String? title,
    String? slug,
    String? description,
    String? imgCover,
    List<String>? images,
    int? productPrice,
    int? priceAfterDiscount,
    int? discount,
    int? sold,
    int? quantity,
    String? productId,
  }) {
    return BestSellerProductEntity(
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      imgCover: imgCover ?? this.imgCover,
      images: images ?? this.images,
      productPrice: productPrice ?? this.productPrice,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      discount: discount ?? this.discount,
      sold: sold ?? this.sold,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
    );
  }
}

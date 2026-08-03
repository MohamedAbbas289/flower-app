import 'package:equatable/equatable.dart';
import 'package:flower_app/core/entities/product_card_data.dart';

class ProductEntity extends Equatable implements ProductCardData {
  final String? rawId;
  final String? title;
  final String? slug;
  final String? description;
  final String? imgCover;
  final List<String>? images;
  final num? rawPrice;
  final num? priceAfterDiscount;
  final num? discount;
  final num? rateAvg;
  final num? rateCount;
  final num? sold;
  final num? quantity;
  final String? categoryId;
  final String? occasionId;
  final bool? isInWishlist;
  final String? favoriteId;

  const ProductEntity({
    String? id,
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    num? price,
    this.priceAfterDiscount,
    this.discount,
    this.rateAvg,
    this.rateCount,
    this.sold,
    this.quantity,
    this.categoryId,
    this.occasionId,
    this.isInWishlist,
    this.favoriteId,
  })  : rawId = id,
        rawPrice = price;

  @override
  String get id => rawId ?? '';

  @override
  String get name => title ?? '';

  @override
  String get imageUrl => imgCover ?? '';

  @override
  int get price => (priceAfterDiscount ?? rawPrice ?? 0).toInt();

  @override
  int? get originalPrice =>
      priceAfterDiscount != null ? rawPrice?.toInt() : null;

  @override
  int? get discountPercent => discount?.toInt();

  @override
  int? get availableQuantity => quantity?.toInt();

  @override
  List<Object?> get props => [
        rawId,
        title,
        slug,
        description,
        imgCover,
        images,
        rawPrice,
        priceAfterDiscount,
        discount,
        rateAvg,
        rateCount,
        sold,
        quantity,
        categoryId,
        occasionId,
        isInWishlist,
        favoriteId,
      ];
}

class OrderProductEntity {
  final String? id;
  final String? title;
  final String? slug;
  final String? description;
  final String? imgCover;
  final List<String>? images;
  final num? price;
  final num? priceAfterDiscount;
  final num? discount;
  final num? rateAvg;
  final num? rateCount;
  final num? sold;
  final num? quantity;
  final String? categoryId;
  final String? occasionId;

  const OrderProductEntity({
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
    this.categoryId,
    this.occasionId,
  });
}

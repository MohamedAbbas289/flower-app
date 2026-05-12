class BestSellerProductEntity {
  String? title;
  String? slug;
  String? description;
  String? imgCover;
  List<String>? images;
  int? price;
  int? priceAfterDiscount;
  int? discount;
  int? sold;
  int? quantity;
  String? id;

  BestSellerProductEntity({
    this.title,
    this.slug,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.discount,
    this.sold,
    this.quantity,
    this.id,
  });
}

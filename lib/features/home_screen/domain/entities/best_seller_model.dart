class BestSellerModel {
  String? id;
  String? title;
  String? slug;
  String? description;
  String? imgCover;
  List<String>? images;
  int? price;
  int? priceAfterDiscount;
  int? discount;
  int? rateAvg;
  int? rateCount;
  int? sold;
  int? quantity;
  String? category;
  String? occasion;
  bool? isSuperAdmin;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? bestSellerId;

  BestSellerModel({
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
}

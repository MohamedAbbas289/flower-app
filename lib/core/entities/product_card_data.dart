abstract interface class ProductCardData {
  String get id;
  String get name;
  String get imageUrl;
  int get price;
  int? get originalPrice;
  int? get discountPercent;
  int? get availableQuantity;
}

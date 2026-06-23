import 'package:flower_app/features/occasions/domain/entities/products_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response.g.dart';

@JsonSerializable()
class ProductsResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "metadata")
  Metadata? metadata;
  @JsonKey(name: "products")
  List<Product>? products;

  ProductsResponse({this.message, this.metadata, this.products});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);
}

@JsonSerializable()
class Metadata {
  @JsonKey(name: "currentPage")
  int? currentPage;
  @JsonKey(name: "totalPages")
  int? totalPages;
  @JsonKey(name: "limit")
  int? limit;
  @JsonKey(name: "totalItems")
  int? totalItems;

  Metadata({this.currentPage, this.totalPages, this.limit, this.totalItems});

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}

@JsonSerializable()
class Product {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "slug")
  String? slug;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "imgCover")
  String? imgCover;
  @JsonKey(name: "images")
  List<String>? images;
  @JsonKey(name: "price")
  int? price;
  @JsonKey(name: "priceAfterDiscount")
  int? priceAfterDiscount;
  @JsonKey(name: "discount")
  int? discount;
  @JsonKey(name: "rateAvg")
  int? rateAvg;
  @JsonKey(name: "rateCount")
  int? rateCount;
  @JsonKey(name: "sold")
  int? sold;
  @JsonKey(name: "quantity")
  int? quantity;
  @JsonKey(name: "category")
  String? category;
  @JsonKey(name: "occasion")
  String? occasion;
  @JsonKey(name: "isSuperAdmin")
  bool? isSuperAdmin;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  DateTime? updatedAt;
  @JsonKey(name: "__v")
  int? v;
  @JsonKey(name: "favoriteId")
  dynamic favoriteId;
  @JsonKey(name: "isInWishlist")
  bool? isInWishlist;

  Product({
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
    this.favoriteId,
    this.isInWishlist,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

extension ProductsMapper on ProductsResponse {
  ProductsEntity toEntity() {
    return ProductsEntity(
      currentPage: metadata?.currentPage ?? 1,
      totalPages: metadata?.totalPages ?? 1,
      products:
          products?.map<ProductEntity>((e) => e.toProductEntity()).toList() ??
          [],
    );
  }
}

extension ProductMapper on Product {
  ProductEntity toProductEntity() {
    return ProductEntity(
      id: id ?? '',
      name: title ?? '',
      imageUrl: imgCover ?? '',
      price: priceAfterDiscount ?? price ?? 0,
      originalPrice: priceAfterDiscount != null ? price : null,
      discountPercent: discount,
    );
  }
}

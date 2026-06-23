import 'package:flower_app/features/home/data/models/occasion_products_response.dart';
import 'package:flower_app/features/home/domain/entities/products_entity.dart';

extension OccasionProductsMapper on OccasionProductsResponse {
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

extension OccasionProductMapper on Product {
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

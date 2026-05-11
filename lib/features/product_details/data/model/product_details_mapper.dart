import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';

extension ProductDetailsMapper on ProductDetailsResponse {
  ProductDetailsEntity toEntity() {
    return ProductDetailsEntity(
      id: product?.id ?? '',
      title: product?.title ?? '',
      price: product?.price ?? 0,
      priceAfterDiscount: product?.priceAfterDiscount ?? 0,
      quantity: product?.quantity ?? 0,
      rateCount: product?.rateCount ?? 0,
      rateAvg: product?.rateAvg?.toDouble() ?? 0.0,
      isInWishlist: product?.isInWishlist ?? false,
      description: product?.description ?? '',
      imgCover: product?.imgCover ?? '',
      images: product?.images ?? [],
    );
  }
}

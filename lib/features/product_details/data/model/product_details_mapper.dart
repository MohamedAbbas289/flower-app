import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';

extension ProductDetailsMapper on ProductDetailsResponse {
  ProductDetailsEntity toEntity() {
    final p = products?.firstOrNull;
    return ProductDetailsEntity(
      id: p?.id ?? '',
      title: p?.title ?? '',
      description: p?.description ?? '',
      images: [if (p?.imgCover != null) p!.imgCover!, ...?p?.images],
      price: p?.price ?? 0,
      priceAfterDiscount: p?.priceAfterDiscount ?? 0,
      quantity: p?.quantity ?? 0,
      rateCount: p?.rateCount ?? 0,
      rateAvg: p?.rateAvg?.toDouble() ?? 0.0,
      isInWishlist: p?.isInWishlist ?? false,
    );
  }
}

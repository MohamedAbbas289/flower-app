import 'package:flower_app/features/home/data/models/occasions_response.dart';
import 'package:flower_app/features/home/domain/entities/occasion_entity.dart';

extension OccasionsMapper on OccasionsResponse {
  OccasionsEntity toEntity() {
    return OccasionsEntity(
      currentPage: metadata?.currentPage ?? 1,
      totalPages: metadata?.totalPages ?? 1,
      occasions:
          occasions
              ?.map<OccasionEntity>((e) => e.toOccasionEntity())
              .toList() ??
          [],
    );
  }
}

extension OccasionMapper on Occasion {
  OccasionEntity toOccasionEntity() {
    return OccasionEntity(
      id: id ?? '',
      name: name ?? '',
      productsCount: productsCount ?? 0,
    );
  }
}

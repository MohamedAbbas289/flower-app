import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/best_seller_product_entity.dart';
import 'package:flower_app/features/home/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_category_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_occasion_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_best_seller_entity.dart';
import 'package:flower_app/features/home/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_response_entity.dart';

abstract interface class HomeRepositoryContract {
  Future<BaseResponse<List<BestSellerProductEntity>>> fetchBestSellers();

  Future<BaseResponse<CategoriesResponseEntity>> getCategories({
    int? page,
    int? limit,
  });

  Future<BaseResponse<ProductsResponseEntity>> getProductsByCategory({
    String? categoryId,
    String? sort,
    int? page,
    int? limit,
  });

  Future<BaseResponse<List<HomeCategoryEntity>>> getAllCategory();

  Future<BaseResponse<List<HomeOccasionEntity>>> getAllOccasion();

  Future<BaseResponse<List<BestSellerEntity>>> getAllBestSeller();

  Future<BaseResponse<OccasionsEntity>> getOccasions({
    required int page,
    required int limit,
  });

  Future<BaseResponse<ProductsEntity>> getProductsByOccasion({
    required String occasionId,
    required int page,
    required int limit,
  });

  Future<BaseResponse<ProductsResponseEntity>> searchProducts({
    required String query,
  });
}

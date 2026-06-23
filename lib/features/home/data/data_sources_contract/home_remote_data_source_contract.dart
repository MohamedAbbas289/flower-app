import '../../../../config/base_response/base_response.dart';
import '../models/best_seller_response.dart';
import '../models/categories_response.dart';
import '../models/category_products_response.dart';
import '../models/home_best_seller_dto.dart';
import '../models/home_category_dto.dart';
import '../models/home_occasion_dto.dart';
import '../models/occasion_products_response.dart';
import '../models/occasions_response.dart';

abstract interface class HomeRemoteDataSourceContract {
  Future<BaseResponse<BestSellerResponse>> fetchBestSellers();

  Future<BaseResponse<CategoriesResponse>> getCategories({
    required int page,
    required int limit,
  });

  Future<BaseResponse<ProductsResponse>> getProductsByCategory({
    String? categoryId,
    String? sort,
    required int page,
    required int limit,
  });

  Future<BaseResponse<List<CategoryDto>>> getAllCategory();

  Future<BaseResponse<List<BestSellerDto>>> getAllBestSeller();

  Future<BaseResponse<List<OccasionDto>>> getAllOccasion();

  Future<BaseResponse<OccasionsResponse>> getOccasions({
    required int page,
    required int limit,
  });

  Future<BaseResponse<OccasionProductsResponse>> getProductsByOccasion({
    required String occasionId,
    required int page,
    required int limit,
  });

  Future<BaseResponse<ProductsResponse>> searchProducts({
    required String query,
  });
}

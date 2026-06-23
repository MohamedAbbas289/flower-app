import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/data/data_sources_contract/home_remote_data_source_contract.dart';
import 'package:flower_app/features/home/data/models/best_seller_response.dart';
import 'package:flower_app/features/home/data/models/categories_response.dart';
import 'package:flower_app/features/home/data/models/category_model.dart';
import 'package:flower_app/features/home/data/models/category_products_response.dart';
import 'package:flower_app/features/home/data/models/home_best_seller_dto.dart';
import 'package:flower_app/features/home/data/models/home_category_dto.dart';
import 'package:flower_app/features/home/data/models/home_occasion_dto.dart';
import 'package:flower_app/features/home/data/models/occasion_products_response.dart';
import 'package:flower_app/features/home/data/models/occasions_response.dart';
import 'package:flower_app/features/home/data/models/product_model.dart';
import 'package:flower_app/features/home/domain/entities/best_seller_product_entity.dart';
import 'package:flower_app/features/home/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/home/domain/entities/category_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_best_seller_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_category_entity.dart';
import 'package:flower_app/features/home/domain/entities/home_occasion_entity.dart';
import 'package:flower_app/features/home/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/home/domain/entities/product_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_entity.dart'
    hide ProductEntity;
import 'package:flower_app/features/home/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/home/domain/mappers/occasion_products_mapper.dart';
import 'package:flower_app/features/home/domain/mappers/occasions_mapper.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepositoryContract)
class HomeRepositoryImpl implements HomeRepositoryContract {
  final HomeRemoteDataSourceContract _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<BestSellerProductEntity>>>
  fetchBestSellers() async {
    final response = await _remoteDataSource.fetchBestSellers();
    switch (response) {
      case SuccessBaseResponse<BestSellerResponse>():
        final products = response.data.bestSeller
            ?.map((productDTO) => productDTO.toEntity())
            .toList();
        return SuccessBaseResponse(data: products ?? []);
      case ErrorBaseResponse<BestSellerResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }

  @override
  Future<BaseResponse<CategoriesResponseEntity>> getCategories({
    int? page,
    int? limit,
  }) async {
    final response = await _remoteDataSource.getCategories(
      page: page ?? 1,
      limit: limit ?? 50,
    );

    switch (response) {
      case SuccessBaseResponse<CategoriesResponse>():
        final entities =
            response.data.categories
                ?.map((e) => e.toEntity())
                .toList()
                .cast<CategoryEntity>() ??
            <CategoryEntity>[];
        final metadata = response.data.metadata?.toEntity();
        return SuccessBaseResponse(
          data: CategoriesResponseEntity(
            categories: entities,
            metadata: metadata,
          ),
        );
      case ErrorBaseResponse<CategoriesResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }

  @override
  Future<BaseResponse<ProductsResponseEntity>> getProductsByCategory({
    String? categoryId,
    String? sort,
    int? page,
    int? limit,
  }) async {
    final response = await _remoteDataSource.getProductsByCategory(
      categoryId: categoryId,
      sort: sort,
      page: page ?? 1,
      limit: limit ?? 10,
    );

    switch (response) {
      case SuccessBaseResponse<ProductsResponse>():
        final entities =
            response.data.products
                ?.map((e) => e.toEntity())
                .toList()
                .cast<ProductEntity>() ??
            <ProductEntity>[];
        final metadata = response.data.metadata?.toEntity();
        return SuccessBaseResponse(
          data: ProductsResponseEntity(products: entities, metadata: metadata),
        );
      case ErrorBaseResponse<ProductsResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }

  @override
  Future<BaseResponse<List<BestSellerEntity>>> getAllBestSeller() async {
    final response = await _remoteDataSource.getAllBestSeller();
    switch (response) {
      case SuccessBaseResponse<List<BestSellerDto>>():
        return SuccessBaseResponse<List<BestSellerEntity>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<BestSellerDto>>():
        return ErrorBaseResponse<List<BestSellerEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<List<HomeCategoryEntity>>> getAllCategory() async {
    final response = await _remoteDataSource.getAllCategory();
    switch (response) {
      case SuccessBaseResponse<List<CategoryDto>>():
        return SuccessBaseResponse<List<HomeCategoryEntity>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<CategoryDto>>():
        return ErrorBaseResponse<List<HomeCategoryEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<List<HomeOccasionEntity>>> getAllOccasion() async {
    final response = await _remoteDataSource.getAllOccasion();
    switch (response) {
      case SuccessBaseResponse<List<OccasionDto>>():
        return SuccessBaseResponse<List<HomeOccasionEntity>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<OccasionDto>>():
        return ErrorBaseResponse<List<HomeOccasionEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<OccasionsEntity>> getOccasions({
    required int page,
    required int limit,
  }) async {
    final response = await _remoteDataSource.getOccasions(
      page: page,
      limit: limit,
    );

    switch (response) {
      case SuccessBaseResponse<OccasionsResponse>():
        final occasions = response.data.toEntity();
        return SuccessBaseResponse<OccasionsEntity>(data: occasions);
      case ErrorBaseResponse<OccasionsResponse>():
        return ErrorBaseResponse<OccasionsEntity>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<ProductsEntity>> getProductsByOccasion({
    required String occasionId,
    required int page,
    required int limit,
  }) async {
    final response = await _remoteDataSource.getProductsByOccasion(
      occasionId: occasionId,
      page: page,
      limit: limit,
    );

    switch (response) {
      case SuccessBaseResponse<OccasionProductsResponse>():
        final data = response.data.toEntity();
        return SuccessBaseResponse<ProductsEntity>(data: data);
      case ErrorBaseResponse<OccasionProductsResponse>():
        return ErrorBaseResponse<ProductsEntity>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<ProductsResponseEntity>> searchProducts({
    required String query,
  }) async {
    final response = await _remoteDataSource.searchProducts(query: query);

    switch (response) {
      case SuccessBaseResponse<ProductsResponse>():
        final entities =
            response.data.products
                ?.map((e) => e.toEntity())
                .toList()
                .cast<ProductEntity>() ??
            <ProductEntity>[];
        final metadata = response.data.metadata?.toEntity();
        return SuccessBaseResponse(
          data: ProductsResponseEntity(products: entities, metadata: metadata),
        );
      case ErrorBaseResponse<ProductsResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/occasions/data/datasources_contract/occasions_remote_datasource_contract.dart';
import 'package:flower_app/features/occasions/data/models/occasions_response.dart';
import 'package:flower_app/features/occasions/data/models/products_response.dart';
import 'package:flower_app/features/occasions/domain/entities/occasion_entity.dart';
import 'package:flower_app/features/occasions/domain/entities/products_entity.dart';
import 'package:flower_app/features/occasions/domain/repositories_contract/occasions_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OccasionsRepositoryContract)
class OccasionsRepositoryImpl implements OccasionsRepositoryContract {
  OccasionsRepositoryImpl(this._remotedatasource);
  final OccasionsRemoteDatasourceContract _remotedatasource;

  @override
  Future<BaseResponse<OccasionsEntity>> getOccasions({
    required int page,
    required int limit,
  }) async {
    final response = await _remotedatasource.getOccasions(
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
    final response = await _remotedatasource.getProductsByOccasion(
      occasionId: occasionId,
      page: page,
      limit: limit,
    );

    switch (response) {
      case SuccessBaseResponse<ProductsResponse>():
        final data = response.data.toEntity();
        return SuccessBaseResponse<ProductsEntity>(data: data);
      case ErrorBaseResponse<ProductsResponse>():
        return ErrorBaseResponse<ProductsEntity>(exception: response.exception);
    }
  }
}

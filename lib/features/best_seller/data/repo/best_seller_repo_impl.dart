import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/best_seller/data/data_source/best_seller_remote_data_source_contract.dart';
import 'package:flower_app/features/best_seller/domain/entity/best_seller_product_entity.dart';
import 'package:flower_app/features/best_seller/domain/repo/best_seller_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BestSellerRepoContract)
class BestSellerRepoImpl implements BestSellerRepoContract {
  final BestSellerRemoteDataSourceContract remoteDataSource;

  BestSellerRepoImpl({required this.remoteDataSource});

  @override
  Future<BaseResponse<List<BestSellerProductEntity>>> fetchBestSellers() async {
    final response = await remoteDataSource.fetchBestSellers();
    switch (response) {
      case SuccessBaseResponse():
        final products = response.data.bestSeller
            ?.map((productDTO) => productDTO.toEntity())
            .toList();
        return SuccessBaseResponse(data: products ?? []);
      case ErrorBaseResponse():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}

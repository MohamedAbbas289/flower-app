import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/best_seller/api/api_client/best_seller_api_client.dart';
import 'package:flower_app/features/best_seller/data/data_source/best_seller_remote_data_source_contract.dart';
import 'package:flower_app/features/best_seller/data/model/best_seller_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BestSellerRemoteDataSourceContract)
class BestSellerRemoteDataSourceImpl implements BestSellerRemoteDataSourceContract{
  final BestSellerApiClient _apiClient;
  BestSellerRemoteDataSourceImpl(this._apiClient);
  @override
  Future<BaseResponse<BestSellerResponse>> fetchBestSellers()async {
    try{
      final response =await _apiClient.fetchBestSellers();
      return SuccessBaseResponse<BestSellerResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<BestSellerResponse>(exception: e);
    }
  }
} 
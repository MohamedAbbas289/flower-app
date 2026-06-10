

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/saved_address/data/data_sources/saved_address_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

import '../saved_address_api_client/saved_address_api_client.dart';

@Injectable(as: SavedAddressRemoteDataSourceContract)
class SavedAddressRemoteDataSourceImpl implements SavedAddressRemoteDataSourceContract{
  final SavedAddressApiClient savedAddressApiClient;
  SavedAddressRemoteDataSourceImpl(this.savedAddressApiClient);

  @override
  Future<BaseResponse<AuthResponse>> getSavedAddress({String? token}) async{
    try{
      final response = await savedAddressApiClient.getSavedAddress(
        token =token
      );
      return SuccessBaseResponse<AuthResponse>(data: response);

    }catch(e){
      return ErrorBaseResponse<AuthResponse>(exception: e);
    }
  }


}
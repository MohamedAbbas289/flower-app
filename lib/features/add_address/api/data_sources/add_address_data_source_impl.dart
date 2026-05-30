

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/data_sources/add_address_data_source_contract.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:injectable/injectable.dart';

import '../api_client/add_address_api_client.dart';

@Injectable(as: AddAddressDataSourceContract)
class AddAddressDataSourceImpl implements AddAddressDataSourceContract {
  final AddAddressApiClient addAddressApiClient;
  AddAddressDataSourceImpl(this.addAddressApiClient);

  @override
  Future<BaseResponse<List<AddAddressDto>>> addNewAddress({
    String? token, required AddAddressDto request}) async {
   try{
     final response = await addAddressApiClient.addNewAddress(
       request: request,
     );
     return SuccessBaseResponse<List<AddAddressDto>>(data: response.address!);
   }catch (e){
     return ErrorBaseResponse<List<AddAddressDto>>(exception: e);
   }

  }
}


import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/edit_address/data/models/edit_address_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';


part 'edit_address_api_client.g.dart';

@injectable
@RestApi()
abstract interface class EditAddressApiClient {
  @factoryMethod
  factory EditAddressApiClient(Dio dio) = _EditAddressApiClient;

  @PATCH(Endpoints.editAddress)
  Future<EditAddressResponse> editAddress({
    @Path(ApiParam.addressId) required String id,
    @Body() required AddAddressDto request,
  });
}
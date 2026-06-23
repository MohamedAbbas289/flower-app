import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/values/endpoints.dart';
import '../../data/models/add_address_dto.dart';
import '../../data/models/add_address_response.dart';
import '../../data/models/delete_address_response.dart';
import '../../data/models/edit_address_response.dart';
import '../../data/models/get_addresses_response.dart';

part 'address_api_client.g.dart';

@injectable
@RestApi()
abstract interface class AddressApiClient {
  @factoryMethod
  factory AddressApiClient(Dio dio) = _AddressApiClient;

  @PATCH(Endpoints.addresses)
  Future<AddAddressResponse> addNewAddress({
    @Body() required AddAddressDto request,
  });

  @PATCH(Endpoints.editAddress)
  Future<EditAddressResponse> editAddress({
    @Path(ApiParam.addressId) required String id,
    @Body() required AddAddressDto request,
  });

  @GET(Endpoints.addresses)
  Future<GetAddressesResponse> getAddresses();

  @DELETE(Endpoints.deleteAddress)
  Future<DeleteAddressResponse> deleteAddress(
    @Path(ApiParam.addressId) String id,
  );
}

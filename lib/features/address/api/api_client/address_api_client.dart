import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:flower_app/features/address/data/models/delete_address_response.dart';
import 'package:flower_app/features/address/data/models/edit_address_response.dart';
import 'package:flower_app/features/address/data/models/get_addresses_response.dart';

part 'address_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class AddressApiClient {
  @factoryMethod
  factory AddressApiClient(Dio dio) = _AddressApiClient;

  @PATCH(Endpoints.addresses)
  Future<AddAddressResponse> addNewAddress({
    @Body() required AddAddressRequestModel request,
  });

  @PATCH(Endpoints.editAddress)
  Future<EditAddressResponse> editAddress({
    @Path(ApiParam.addressId) required String id,
    @Body() required AddAddressRequestModel request,
  });

  @GET(Endpoints.addresses)
  Future<GetAddressesResponse> getAddresses();

  @DELETE(Endpoints.deleteAddress)
  Future<DeleteAddressResponse> deleteAddress(
    @Path(ApiParam.addressId) String id,
  );
}

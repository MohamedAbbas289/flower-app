import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/features/saved_address/data/models/delete_address_response.dart';
import 'package:flower_app/features/saved_address/data/models/get_addresses_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/values/endpoints.dart';

part 'saved_address_api_client.g.dart';

@injectable
@RestApi()
abstract interface class SavedAddressApiClient {
  @factoryMethod
  factory SavedAddressApiClient(Dio dio) = _SavedAddressApiClient;

  @GET(Endpoints.addresses)
  Future<GetAddressesResponse> getAddresses();

  @DELETE(Endpoints.deleteAddress)
  Future<DeleteAddressResponse> deleteAddress(
    @Path(ApiParam.addressId) String id,
  );
}

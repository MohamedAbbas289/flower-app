import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/values/endpoints.dart';
import '../../data/models/add_address_dto.dart';
import '../../data/models/add_address_response.dart';
part 'add_address_api_client.g.dart';

@injectable
@RestApi()
abstract interface class AddAddressApiClient {
  @factoryMethod
  factory AddAddressApiClient(Dio dio) = _AddAddressApiClient;
  @PATCH(Endpoints.addresses)
  Future<AddAddressResponse> addNewAddress({
    @Body() required AddAddressDto request,
  });
}

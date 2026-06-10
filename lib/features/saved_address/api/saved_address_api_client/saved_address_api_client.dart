


import 'package:dio/dio.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/values/endpoints.dart';
import '../../../../core/values/secure_storage_keys.dart';
part 'saved_address_api_client.g.dart';

@injectable
@RestApi()
abstract class SavedAddressApiClient {
  @factoryMethod
  factory SavedAddressApiClient(Dio dio) = _SavedAddressApiClient;

  @GET(Endpoints.addresses)
  Future<AuthResponse> getSavedAddress(
      @Header(SecureStorageKeys.token) String? token, );
}
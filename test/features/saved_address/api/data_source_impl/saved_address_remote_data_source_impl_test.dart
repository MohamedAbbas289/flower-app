import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/saved_address/api/data_source_impl/saved_address_remote_data_source_impl.dart';
import 'package:flower_app/features/saved_address/api/saved_address_api_client/saved_address_api_client.dart';
import 'package:flower_app/features/saved_address/data/models/delete_address_response.dart';
import 'package:flower_app/features/saved_address/data/models/get_addresses_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_address_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([SavedAddressApiClient])
void main() {
  late MockSavedAddressApiClient savedAddressApiClient;
  late SavedAddressDataSourceImpl dataSource;

  setUp(() {
    savedAddressApiClient = MockSavedAddressApiClient();
    dataSource = SavedAddressDataSourceImpl(savedAddressApiClient);
  });

  group('SavedAddressDataSourceImpl - getAddresses', () {
    test('returns SuccessBaseResponse when api call succeeds', () async {
      final response = GetAddressesResponse(message: 'Success', addresses: []);

      when(savedAddressApiClient.getAddresses()).thenAnswer((_) async => response);

      final result = await dataSource.getAddresses();

      expect(result, isA<SuccessBaseResponse<GetAddressesResponse>>());
      expect((result as SuccessBaseResponse<GetAddressesResponse>).data, response);

      verify(savedAddressApiClient.getAddresses()).called(1);
      verifyNoMoreInteractions(savedAddressApiClient);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final exception = Exception('network error');

      when(savedAddressApiClient.getAddresses()).thenThrow(exception);

      final result = await dataSource.getAddresses();

      expect(result, isA<ErrorBaseResponse<GetAddressesResponse>>());
      expect((result as ErrorBaseResponse<GetAddressesResponse>).exception, exception);

      verify(savedAddressApiClient.getAddresses()).called(1);
      verifyNoMoreInteractions(savedAddressApiClient);
    });
  });

  group('SavedAddressDataSourceImpl - deleteAddress', () {
    test('returns SuccessBaseResponse with true when api call succeeds', () async {
      final response = DeleteAddressResponse(message: 'Deleted');

      when(savedAddressApiClient.deleteAddress('1')).thenAnswer((_) async => response);

      final result = await dataSource.deleteAddress('1');

      expect(result, isA<SuccessBaseResponse<bool>>());
      expect((result as SuccessBaseResponse<bool>).data, true);

      verify(savedAddressApiClient.deleteAddress('1')).called(1);
      verifyNoMoreInteractions(savedAddressApiClient);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final exception = Exception('network error');

      when(savedAddressApiClient.deleteAddress('1')).thenThrow(exception);

      final result = await dataSource.deleteAddress('1');

      expect(result, isA<ErrorBaseResponse<bool>>());
      expect((result as ErrorBaseResponse<bool>).exception, exception);

      verify(savedAddressApiClient.deleteAddress('1')).called(1);
      verifyNoMoreInteractions(savedAddressApiClient);
    });
  });
}

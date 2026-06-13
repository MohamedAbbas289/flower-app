import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/api/api_client/add_address_api_client.dart';
import 'package:flower_app/features/add_address/api/data_sources/add_address_data_source_impl.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/data/models/add_address_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_address_data_source_impl_test.mocks.dart';

@GenerateMocks([AddAddressApiClient])
void main() {
  late MockAddAddressApiClient addAddressApiClient;
  late AddAddressDataSourceImpl dataSource;

  final request = AddAddressDto(
    street: 'Ahmed',
    phone: '0102419753',
    city: 'cairo',
    lat: '30.08525452318584',
    long: '31.282610287469513',
    username: 'ahmed',
  );

  setUp(() {
    addAddressApiClient = MockAddAddressApiClient();
    dataSource = AddAddressDataSourceImpl(addAddressApiClient);
  });

  group('AddAddressDataSourceImpl', () {
    test('returns SuccessBaseResponse when api returns an address list', () async {
      final dto = AddAddressDto(
        id: '1',
        street: 'Ahmed',
        phone: '0102419753',
        city: 'cairo',
      );

      when(addAddressApiClient.addNewAddress(request: request)).thenAnswer(
        (_) async => AddAddressResponse(message: 'Success', address: [dto]),
      );

      final result = await dataSource.addNewAddress(request: request);

      expect(result, isA<SuccessBaseResponse<List<AddAddressDto>>>());
      expect((result as SuccessBaseResponse<List<AddAddressDto>>).data, [dto]);

      verify(addAddressApiClient.addNewAddress(request: request)).called(1);
      verifyNoMoreInteractions(addAddressApiClient);
    });

    test('returns ErrorBaseResponse when api response has a null address', () async {
      when(addAddressApiClient.addNewAddress(request: request)).thenAnswer(
        (_) async => AddAddressResponse(message: 'No address'),
      );

      final result = await dataSource.addNewAddress(request: request);

      expect(result, isA<ErrorBaseResponse<List<AddAddressDto>>>());
      expect(
        (result as ErrorBaseResponse<List<AddAddressDto>>).exception.toString(),
        contains('addressMissingOrNull'),
      );

      verify(addAddressApiClient.addNewAddress(request: request)).called(1);
      verifyNoMoreInteractions(addAddressApiClient);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final exception = Exception('network error');

      when(addAddressApiClient.addNewAddress(request: request)).thenThrow(exception);

      final result = await dataSource.addNewAddress(request: request);

      expect(result, isA<ErrorBaseResponse<List<AddAddressDto>>>());
      expect((result as ErrorBaseResponse<List<AddAddressDto>>).exception, exception);

      verify(addAddressApiClient.addNewAddress(request: request)).called(1);
      verifyNoMoreInteractions(addAddressApiClient);
    });
  });
}

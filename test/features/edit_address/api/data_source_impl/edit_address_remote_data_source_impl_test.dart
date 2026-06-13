import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/edit_address/api/data_source_impl/edit_address_remote_data_source_impl.dart';
import 'package:flower_app/features/edit_address/api/edit_address_api_client/edit_address_api_client.dart';
import 'package:flower_app/features/edit_address/data/models/edit_address_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_address_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([EditAddressApiClient])
void main() {
  late MockEditAddressApiClient editAddressApiClient;
  late EditAddressRemoteDataSourceImpl dataSource;

  final request = AddAddressDto(
    street: 'Ahmed',
    phone: '0102419753',
    city: 'cairo',
    lat: '30.08525452318584',
    long: '31.282610287469513',
    username: 'ahmed',
  );

  setUp(() {
    editAddressApiClient = MockEditAddressApiClient();
    dataSource = EditAddressRemoteDataSourceImpl(editAddressApiClient);
  });

  group('EditAddressRemoteDataSourceImpl', () {
    test('returns SuccessBaseResponse when api call succeeds', () async {
      final dto = AddAddressDto(id: '1', street: 'Ahmed', city: 'cairo');
      final response = EditAddressResponse(message: 'Success', addresses: [dto]);

      when(editAddressApiClient.editAddress(id: '1', request: request)).thenAnswer(
        (_) async => response,
      );

      final result = await dataSource.editAddress(id: '1', request: request);

      expect(result, isA<SuccessBaseResponse<EditAddressResponse>>());
      expect((result as SuccessBaseResponse<EditAddressResponse>).data, response);

      verify(editAddressApiClient.editAddress(id: '1', request: request)).called(1);
      verifyNoMoreInteractions(editAddressApiClient);
    });

    test('returns ErrorBaseResponse when api throws an exception', () async {
      final exception = Exception('network error');

      when(editAddressApiClient.editAddress(id: '1', request: request)).thenThrow(exception);

      final result = await dataSource.editAddress(id: '1', request: request);

      expect(result, isA<ErrorBaseResponse<EditAddressResponse>>());
      expect((result as ErrorBaseResponse<EditAddressResponse>).exception, exception);

      verify(editAddressApiClient.editAddress(id: '1', request: request)).called(1);
      verifyNoMoreInteractions(editAddressApiClient);
    });
  });
}

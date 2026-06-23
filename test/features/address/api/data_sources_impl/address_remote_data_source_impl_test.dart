import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/api/api_client/address_api_client.dart';
import 'package:flower_app/features/address/api/data_sources_impl/address_remote_data_source_impl.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/data/models/add_address_response.dart';
import 'package:flower_app/features/address/data/models/delete_address_response.dart';
import 'package:flower_app/features/address/data/models/edit_address_response.dart';
import 'package:flower_app/features/address/data/models/get_addresses_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AddressApiClient])
void main() {
  late MockAddressApiClient addressApiClient;
  late AddressRemoteDataSourceImpl dataSource;

  final request = AddAddressDto(
    street: 'Ahmed',
    phone: '0102419753',
    city: 'cairo',
    lat: '30.08525452318584',
    long: '31.282610287469513',
    username: 'ahmed',
  );

  setUp(() {
    addressApiClient = MockAddressApiClient();
    dataSource = AddressRemoteDataSourceImpl(addressApiClient);
  });

  group('AddressRemoteDataSourceImpl', () {
    group('addNewAddress', () {
      test(
        'returns SuccessBaseResponse when api returns an address list',
        () async {
          final dto = AddAddressDto(
            id: '1',
            street: 'Ahmed',
            phone: '0102419753',
            city: 'cairo',
          );

          when(addressApiClient.addNewAddress(request: request)).thenAnswer(
            (_) async =>
                AddAddressResponse(message: 'Success', address: [dto]),
          );

          final result = await dataSource.addNewAddress(request: request);

          expect(result, isA<SuccessBaseResponse<List<AddAddressDto>>>());
          expect(
            (result as SuccessBaseResponse<List<AddAddressDto>>).data,
            [dto],
          );

          verify(addressApiClient.addNewAddress(request: request)).called(1);
        },
      );

      test(
        'returns ErrorBaseResponse when api response has a null address',
        () async {
          when(addressApiClient.addNewAddress(request: request)).thenAnswer(
            (_) async => AddAddressResponse(message: 'No address'),
          );

          final result = await dataSource.addNewAddress(request: request);

          expect(result, isA<ErrorBaseResponse<List<AddAddressDto>>>());
          expect(
            (result as ErrorBaseResponse<List<AddAddressDto>>).exception
                .toString(),
            contains('addressMissingOrNull'),
          );

          verify(addressApiClient.addNewAddress(request: request)).called(1);
        },
      );

      test('returns ErrorBaseResponse when api throws an exception', () async {
        final exception = Exception('network error');

        when(
          addressApiClient.addNewAddress(request: request),
        ).thenThrow(exception);

        final result = await dataSource.addNewAddress(request: request);

        expect(result, isA<ErrorBaseResponse<List<AddAddressDto>>>());
        expect(
          (result as ErrorBaseResponse<List<AddAddressDto>>).exception,
          exception,
        );

        verify(addressApiClient.addNewAddress(request: request)).called(1);
      });
    });

    group('editAddress', () {
      test('returns SuccessBaseResponse when api call succeeds', () async {
        final dto = AddAddressDto(id: '1', street: 'Ahmed', city: 'cairo');
        final response = EditAddressResponse(
          message: 'Success',
          addresses: [dto],
        );

        when(
          addressApiClient.editAddress(id: '1', request: request),
        ).thenAnswer((_) async => response);

        final result = await dataSource.editAddress(
          id: '1',
          request: request,
        );

        expect(result, isA<SuccessBaseResponse<EditAddressResponse>>());
        expect(
          (result as SuccessBaseResponse<EditAddressResponse>).data,
          response,
        );

        verify(
          addressApiClient.editAddress(id: '1', request: request),
        ).called(1);
      });

      test('returns ErrorBaseResponse when api throws an exception', () async {
        final exception = Exception('network error');

        when(
          addressApiClient.editAddress(id: '1', request: request),
        ).thenThrow(exception);

        final result = await dataSource.editAddress(
          id: '1',
          request: request,
        );

        expect(result, isA<ErrorBaseResponse<EditAddressResponse>>());
        expect(
          (result as ErrorBaseResponse<EditAddressResponse>).exception,
          exception,
        );

        verify(
          addressApiClient.editAddress(id: '1', request: request),
        ).called(1);
      });
    });

    group('getAddresses', () {
      test('returns SuccessBaseResponse when api call succeeds', () async {
        final response = GetAddressesResponse(
          message: 'Success',
          addresses: [],
        );

        when(
          addressApiClient.getAddresses(),
        ).thenAnswer((_) async => response);

        final result = await dataSource.getAddresses();

        expect(result, isA<SuccessBaseResponse<GetAddressesResponse>>());
        expect(
          (result as SuccessBaseResponse<GetAddressesResponse>).data,
          response,
        );

        verify(addressApiClient.getAddresses()).called(1);
      });

      test('returns ErrorBaseResponse when api throws an exception', () async {
        final exception = Exception('network error');

        when(addressApiClient.getAddresses()).thenThrow(exception);

        final result = await dataSource.getAddresses();

        expect(result, isA<ErrorBaseResponse<GetAddressesResponse>>());
        expect(
          (result as ErrorBaseResponse<GetAddressesResponse>).exception,
          exception,
        );

        verify(addressApiClient.getAddresses()).called(1);
      });
    });

    group('deleteAddress', () {
      test(
        'returns SuccessBaseResponse with true when api call succeeds',
        () async {
          final response = DeleteAddressResponse(message: 'Deleted');

          when(
            addressApiClient.deleteAddress('1'),
          ).thenAnswer((_) async => response);

          final result = await dataSource.deleteAddress('1');

          expect(result, isA<SuccessBaseResponse<bool>>());
          expect((result as SuccessBaseResponse<bool>).data, true);

          verify(addressApiClient.deleteAddress('1')).called(1);
        },
      );

      test('returns ErrorBaseResponse when api throws an exception', () async {
        final exception = Exception('network error');

        when(addressApiClient.deleteAddress('1')).thenThrow(exception);

        final result = await dataSource.deleteAddress('1');

        expect(result, isA<ErrorBaseResponse<bool>>());
        expect(
          (result as ErrorBaseResponse<bool>).exception,
          exception,
        );

        verify(addressApiClient.deleteAddress('1')).called(1);
      });
    });
  });
}

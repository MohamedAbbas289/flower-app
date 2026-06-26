import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flower_app/features/address/data/data_sources_contract/address_remote_data_source_contract.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/data/models/edit_address_response.dart';
import 'package:flower_app/features/address/data/models/get_addresses_response.dart';
import 'package:flower_app/features/address/data/repository_impl/address_repository_impl.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'address_repository_impl_test.mocks.dart';

@GenerateMocks([AddressRemoteDataSourceContract])
void main() {
  late MockAddressRemoteDataSourceContract dataSourceContract;
  late AddressRepositoryImpl repo;

  final request = AddAddressRequestModel(
    street: 'Ahmed',
    phone: '0102419753',
    city: 'cairo',
    lat: '30.08525452318584',
    long: '31.282610287469513',
    username: 'ahmed',
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<AddAddressDto>>>(
      SuccessBaseResponse<List<AddAddressDto>>(data: [AddAddressDto()]),
    );
    provideDummy<BaseResponse<List<AddAddressDto>>>(
      ErrorBaseResponse<List<AddAddressDto>>(exception: Exception()),
    );
    provideDummy<BaseResponse<EditAddressResponse>>(
      SuccessBaseResponse<EditAddressResponse>(
        data: const EditAddressResponse(),
      ),
    );
    provideDummy<BaseResponse<EditAddressResponse>>(
      ErrorBaseResponse<EditAddressResponse>(exception: Exception()),
    );
    provideDummy<BaseResponse<GetAddressesResponse>>(
      SuccessBaseResponse<GetAddressesResponse>(
        data: const GetAddressesResponse(),
      ),
    );
    provideDummy<BaseResponse<GetAddressesResponse>>(
      ErrorBaseResponse<GetAddressesResponse>(exception: Exception()),
    );
    provideDummy<BaseResponse<bool>>(SuccessBaseResponse<bool>(data: true));
    provideDummy<BaseResponse<bool>>(
      ErrorBaseResponse<bool>(exception: Exception()),
    );
  });

  setUp(() {
    dataSourceContract = MockAddressRemoteDataSourceContract();
    repo = AddressRepositoryImpl(dataSourceContract);
  });

  group('AddressRepositoryImpl', () {
    group('addNewAddress', () {
      test('returns success entity when datasource succeeds', () async {
        final dto = AddAddressDto(
          id: '1',
          street: 'Ahmed',
          phone: '0102419753',
          city: 'cairo',
          lat: '30.08525452318584',
          long: '31.282610287469513',
          username: 'ahmed',
        );

        when(
          dataSourceContract.addNewAddress(request: request),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<List<AddAddressDto>>(data: [dto]),
        );

        final result = await repo.addNewAddress(request: request);

        expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
        final entities =
            (result as SuccessBaseResponse<List<AddressEntity>>).data;
        expect(entities.length, 1);
        expect(entities.first.id, dto.id);
        expect(entities.first.street, dto.street);
        expect(entities.first.phone, dto.phone);
        expect(entities.first.city, dto.city);

        verify(dataSourceContract.addNewAddress(request: request)).called(1);
      });

      test('returns error response when datasource fails', () async {
        final exception = Exception();

        when(
          dataSourceContract.addNewAddress(request: request),
        ).thenAnswer(
          (_) async =>
              ErrorBaseResponse<List<AddAddressDto>>(exception: exception),
        );

        final result = await repo.addNewAddress(request: request);

        expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
        expect(
          (result as ErrorBaseResponse<List<AddressEntity>>).exception,
          exception,
        );

        verify(dataSourceContract.addNewAddress(request: request)).called(1);
      });
    });

    group('editAddress', () {
      test(
        'returns success entities when datasource succeeds with addresses',
        () async {
          final dto = AddAddressDto(
            id: '1',
            street: 'Ahmed',
            phone: '0102419753',
            city: 'cairo',
          );

          when(
            dataSourceContract.editAddress(id: '1', request: request),
          ).thenAnswer(
            (_) async => SuccessBaseResponse<EditAddressResponse>(
              data: EditAddressResponse(message: 'Success', addresses: [dto]),
            ),
          );

          final result = await repo.editAddress(id: '1', request: request);

          expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
          final entities =
              (result as SuccessBaseResponse<List<AddressEntity>>).data;
          expect(entities.length, 1);
          expect(entities.first.id, dto.id);
          expect(entities.first.street, dto.street);
          expect(entities.first.phone, dto.phone);
          expect(entities.first.city, dto.city);

          verify(
            dataSourceContract.editAddress(id: '1', request: request),
          ).called(1);
        },
      );

      test('returns ErrorBaseResponse when addresses is null', () async {
        when(
          dataSourceContract.editAddress(id: '1', request: request),
        ).thenAnswer(
          (_) async => SuccessBaseResponse<EditAddressResponse>(
            data: const EditAddressResponse(message: 'Success'),
          ),
        );

        final result = await repo.editAddress(id: '1', request: request);

        expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
        expect(
          (result as ErrorBaseResponse<List<AddressEntity>>).errorMessage,
          'somethingWentWrong',
        );

        verify(
          dataSourceContract.editAddress(id: '1', request: request),
        ).called(1);
      });

      test('returns error response when datasource fails', () async {
        final exception = Exception('boom');

        when(
          dataSourceContract.editAddress(id: '1', request: request),
        ).thenAnswer(
          (_) async =>
              ErrorBaseResponse<EditAddressResponse>(exception: exception),
        );

        final result = await repo.editAddress(id: '1', request: request);

        expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
        expect(
          (result as ErrorBaseResponse<List<AddressEntity>>).exception,
          exception,
        );

        verify(
          dataSourceContract.editAddress(id: '1', request: request),
        ).called(1);
      });
    });

    group('getAddresses', () {
      test(
        'returns success entities when datasource succeeds with addresses',
        () async {
          final dto = AddAddressDto(
            id: '1',
            street: 'Ahmed',
            phone: '0102419753',
            city: 'cairo',
          );

          when(dataSourceContract.getAddresses()).thenAnswer(
            (_) async => SuccessBaseResponse<GetAddressesResponse>(
              data: GetAddressesResponse(message: 'Success', addresses: [dto]),
            ),
          );

          final result = await repo.getAddresses();

          expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
          final entities =
              (result as SuccessBaseResponse<List<AddressEntity>>).data;
          expect(entities.length, 1);
          expect(entities.first.id, dto.id);
          expect(entities.first.street, dto.street);
          expect(entities.first.phone, dto.phone);
          expect(entities.first.city, dto.city);

          verify(dataSourceContract.getAddresses()).called(1);
        },
      );

      test('returns ErrorBaseResponse when addresses is null', () async {
        when(dataSourceContract.getAddresses()).thenAnswer(
          (_) async => SuccessBaseResponse<GetAddressesResponse>(
            data: const GetAddressesResponse(message: 'Success'),
          ),
        );

        final result = await repo.getAddresses();

        expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
        expect(
          (result as ErrorBaseResponse<List<AddressEntity>>).errorMessage,
          'somethingWentWrong',
        );

        verify(dataSourceContract.getAddresses()).called(1);
      });

      test('returns error response when datasource fails', () async {
        final exception = Exception('boom');

        when(dataSourceContract.getAddresses()).thenAnswer(
          (_) async =>
              ErrorBaseResponse<GetAddressesResponse>(exception: exception),
        );

        final result = await repo.getAddresses();

        expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
        expect(
          (result as ErrorBaseResponse<List<AddressEntity>>).exception,
          exception,
        );

        verify(dataSourceContract.getAddresses()).called(1);
      });
    });

    group('deleteAddress', () {
      test(
        'returns SuccessBaseResponse with true when datasource succeeds',
        () async {
          when(
            dataSourceContract.deleteAddress('1'),
          ).thenAnswer((_) async => SuccessBaseResponse<bool>(data: true));

          final result = await repo.deleteAddress('1');

          expect(result, isA<SuccessBaseResponse<bool>>());
          expect((result as SuccessBaseResponse<bool>).data, true);

          verify(dataSourceContract.deleteAddress('1')).called(1);
        },
      );

      test('returns ErrorBaseResponse when datasource fails', () async {
        final exception = Exception('boom');

        when(dataSourceContract.deleteAddress('1')).thenAnswer(
          (_) async => ErrorBaseResponse<bool>(exception: exception),
        );

        final result = await repo.deleteAddress('1');

        expect(result, isA<ErrorBaseResponse<bool>>());
        expect((result as ErrorBaseResponse<bool>).exception, exception);

        verify(dataSourceContract.deleteAddress('1')).called(1);
      });
    });
  });
}

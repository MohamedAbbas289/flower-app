import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/saved_address/data/data_sources_contract/saved_address_remote_data_source_contract.dart';
import 'package:flower_app/features/saved_address/data/models/get_addresses_response.dart';
import 'package:flower_app/features/saved_address/data/repositories_impl/saved_address_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_address_repo_impl_test.mocks.dart';

@GenerateMocks([SavedAddressDataSourceContract])
void main() {
  late MockSavedAddressDataSourceContract dataSourceContract;
  late SavedAddressRepoImpl repo;

  setUpAll(() {
    provideDummy<BaseResponse<GetAddressesResponse>>(
      SuccessBaseResponse<GetAddressesResponse>(data: const GetAddressesResponse()),
    );
    provideDummy<BaseResponse<GetAddressesResponse>>(
      ErrorBaseResponse<GetAddressesResponse>(exception: Exception()),
    );
    provideDummy<BaseResponse<bool>>(SuccessBaseResponse<bool>(data: true));
    provideDummy<BaseResponse<bool>>(ErrorBaseResponse<bool>(exception: Exception()));
  });

  setUp(() {
    dataSourceContract = MockSavedAddressDataSourceContract();
    repo = SavedAddressRepoImpl(dataSourceContract);
  });

  group('SavedAddressRepoImpl - getAddresses', () {
    test('returns success entities when datasource succeeds with addresses', () async {
      final dto = AddAddressDto(id: '1', street: 'Ahmed', phone: '0102419753', city: 'cairo');

      when(dataSourceContract.getAddresses()).thenAnswer(
        (_) async => SuccessBaseResponse<GetAddressesResponse>(
          data: GetAddressesResponse(message: 'Success', addresses: [dto]),
        ),
      );

      final result = await repo.getAddresses();

      expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
      final entities = (result as SuccessBaseResponse<List<AddressEntity>>).data;
      expect(entities.length, 1);
      expect(entities.first.id, dto.id);
      expect(entities.first.street, dto.street);
      expect(entities.first.phone, dto.phone);
      expect(entities.first.city, dto.city);

      verify(dataSourceContract.getAddresses()).called(1);
      verifyNoMoreInteractions(dataSourceContract);
    });

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
      verifyNoMoreInteractions(dataSourceContract);
    });

    test('returns error response when datasource fails', () async {
      final exception = Exception('boom');

      when(dataSourceContract.getAddresses()).thenAnswer(
        (_) async => ErrorBaseResponse<GetAddressesResponse>(exception: exception),
      );

      final result = await repo.getAddresses();

      expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
      expect((result as ErrorBaseResponse<List<AddressEntity>>).exception, exception);

      verify(dataSourceContract.getAddresses()).called(1);
      verifyNoMoreInteractions(dataSourceContract);
    });
  });

  group('SavedAddressRepoImpl - deleteAddress', () {
    test('returns SuccessBaseResponse with true when datasource succeeds', () async {
      when(dataSourceContract.deleteAddress('1')).thenAnswer(
        (_) async => SuccessBaseResponse<bool>(data: true),
      );

      final result = await repo.deleteAddress('1');

      expect(result, isA<SuccessBaseResponse<bool>>());
      expect((result as SuccessBaseResponse<bool>).data, true);

      verify(dataSourceContract.deleteAddress('1')).called(1);
      verifyNoMoreInteractions(dataSourceContract);
    });

    test('returns ErrorBaseResponse when datasource fails', () async {
      final exception = Exception('boom');

      when(dataSourceContract.deleteAddress('1')).thenAnswer(
        (_) async => ErrorBaseResponse<bool>(exception: exception),
      );

      final result = await repo.deleteAddress('1');

      expect(result, isA<ErrorBaseResponse<bool>>());
      expect((result as ErrorBaseResponse<bool>).exception, exception);

      verify(dataSourceContract.deleteAddress('1')).called(1);
      verifyNoMoreInteractions(dataSourceContract);
    });
  });
}

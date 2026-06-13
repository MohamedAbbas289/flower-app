import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/edit_address/data/data_sources_contract/edit_address_remote_data_source_contract.dart';
import 'package:flower_app/features/edit_address/data/models/edit_address_response.dart';
import 'package:flower_app/features/edit_address/data/repositories_impl/edit_address_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_address_repo_impl_test.mocks.dart';

@GenerateMocks([EditAddressRemoteDataSourceContract])
void main() {
  late MockEditAddressRemoteDataSourceContract dataSourceContract;
  late EditAddressRepoImpl repo;

  final request = AddAddressDto(
    street: 'Ahmed',
    phone: '0102419753',
    city: 'cairo',
    lat: '30.08525452318584',
    long: '31.282610287469513',
    username: 'ahmed',
  );

  setUpAll(() {
    provideDummy<BaseResponse<EditAddressResponse>>(
      SuccessBaseResponse<EditAddressResponse>(data: const EditAddressResponse()),
    );
    provideDummy<BaseResponse<EditAddressResponse>>(
      ErrorBaseResponse<EditAddressResponse>(exception: Exception()),
    );
  });

  setUp(() {
    dataSourceContract = MockEditAddressRemoteDataSourceContract();
    repo = EditAddressRepoImpl(dataSourceContract);
  });

  group('EditAddressRepoImpl', () {
    test('returns success entities when datasource succeeds with addresses', () async {
      final dto = AddAddressDto(id: '1', street: 'Ahmed', phone: '0102419753', city: 'cairo');

      when(dataSourceContract.editAddress(id: '1', request: request)).thenAnswer(
        (_) async => SuccessBaseResponse<EditAddressResponse>(
          data: EditAddressResponse(message: 'Success', addresses: [dto]),
        ),
      );

      final result = await repo.editAddress(id: '1', request: request);

      expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
      final entities = (result as SuccessBaseResponse<List<AddressEntity>>).data;
      expect(entities.length, 1);
      expect(entities.first.id, dto.id);
      expect(entities.first.street, dto.street);
      expect(entities.first.phone, dto.phone);
      expect(entities.first.city, dto.city);

      verify(dataSourceContract.editAddress(id: '1', request: request)).called(1);
      verifyNoMoreInteractions(dataSourceContract);
    });

    test('returns ErrorBaseResponse when addresses is null', () async {
      when(dataSourceContract.editAddress(id: '1', request: request)).thenAnswer(
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

      verify(dataSourceContract.editAddress(id: '1', request: request)).called(1);
      verifyNoMoreInteractions(dataSourceContract);
    });

    test('returns error response when datasource fails', () async {
      final exception = Exception('boom');

      when(dataSourceContract.editAddress(id: '1', request: request)).thenAnswer(
        (_) async => ErrorBaseResponse<EditAddressResponse>(exception: exception),
      );

      final result = await repo.editAddress(id: '1', request: request);

      expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
      expect((result as ErrorBaseResponse<List<AddressEntity>>).exception, exception);

      verify(dataSourceContract.editAddress(id: '1', request: request)).called(1);
      verifyNoMoreInteractions(dataSourceContract);
    });
  });
}

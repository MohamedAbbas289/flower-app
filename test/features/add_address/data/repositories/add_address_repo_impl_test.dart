

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/data_sources/add_address_data_source_contract.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/data/repositories/add_address_repo_impl.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'add_address_repo_impl_test.mocks.dart';

@GenerateMocks([AddAddressDataSourceContract])

void main (){
  late MockAddAddressDataSourceContract addAddressDataSourceContract;
  late AddAddressRepoImpl addAddressRepoImpl;

  final request = AddAddressDto(
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
  });
  setUp(() {
    addAddressDataSourceContract = MockAddAddressDataSourceContract();
    addAddressRepoImpl = AddAddressRepoImpl(addAddressDataSourceContract);
  });

    group('AddAddressRepoImpl', () {
      test('returns success entity when datasource succeeds', () async {
        final dto = AddAddressDto(
          id: '1',
          street: 'Ahmed',
          phone: '0102419753',
          city: 'cairo',
          lat: '30.08525452318584',
          long: '31.282610287469513',
          username: 'ahmed');

        when(
          addAddressDataSourceContract.addNewAddress(request: request),
        ).thenAnswer((_) async => SuccessBaseResponse<List<AddAddressDto>>(data: [dto]));

        final result = await addAddressRepoImpl.addNewAddress(request: request);

        expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
        final entity = (result as SuccessBaseResponse<List<AddressEntity>>).data;
    });
      test('returns error response when datasource fails', () async {
        final exception = Exception();
        when(
          addAddressDataSourceContract.addNewAddress(request: request),
        ).thenAnswer(
              (_) async => ErrorBaseResponse<List<AddAddressDto>>(exception: exception),
        );
        final result = await addAddressRepoImpl.addNewAddress(request: request);
        expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
        expect((result as ErrorBaseResponse<List<AddressEntity>>).exception, exception);
        verify(addAddressDataSourceContract.addNewAddress(request: request)).called(1);
        verifyNoMoreInteractions(addAddressDataSourceContract);


      });

      



      });
        }
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repository_contract/address_repository_contract.dart';
import 'package:flower_app/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_address_use_cases_test.mocks.dart';

@GenerateMocks([AddressRepositoryContract])
void main() {
  late MockAddressRepositoryContract addressRepositoryContract;
  late AddAddressUseCase addAddressUseCase;

  final request = AddAddressRequestModel(
    street: 'Ahmed',
    phone: '0102419753',
    city: 'cairo',
    lat: '30.08525452318584',
    long: '31.282610287469513',
    username: 'ahmed',
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse<List<AddressEntity>>(data: const [AddressEntity()]),
    );
    provideDummy<BaseResponse<List<AddressEntity>>>(
      ErrorBaseResponse<List<AddressEntity>>(exception: Exception()),
    );
  });

  setUp(() {
    addressRepositoryContract = MockAddressRepositoryContract();
    addAddressUseCase = AddAddressUseCase(addressRepositoryContract);
  });

  group('AddAddressUseCase', () {
    test('returns success response when repository succeeds', () async {
      final response = SuccessBaseResponse<List<AddressEntity>>(
        data: const [AddressEntity()],
      );
      when(
        addressRepositoryContract.addNewAddress(request: request),
      ).thenAnswer((_) async => response);

      final result = await addAddressUseCase.execute(request: request);

      expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
      expect(
        (result as SuccessBaseResponse<List<AddressEntity>>).data,
        const [AddressEntity()],
      );
      verify(
        addressRepositoryContract.addNewAddress(request: request),
      ).called(1);
      verifyNoMoreInteractions(addressRepositoryContract);
    });

    test('returns error response when repository fails', () async {
      final exception = Exception();
      final response = ErrorBaseResponse<List<AddressEntity>>(
        exception: exception,
      );
      when(
        addressRepositoryContract.addNewAddress(request: request),
      ).thenAnswer((_) async => response);

      final result = await addAddressUseCase.execute(request: request);

      expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
      expect(
        (result as ErrorBaseResponse<List<AddressEntity>>).exception,
        exception,
      );
      verify(
        addressRepositoryContract.addNewAddress(request: request),
      ).called(1);
      verifyNoMoreInteractions(addressRepositoryContract);
    });
  });
}

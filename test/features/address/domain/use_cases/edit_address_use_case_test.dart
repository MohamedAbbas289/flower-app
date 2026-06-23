import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/edit_address/domain/repositories_contract/edit_address_repo_contract.dart';
import 'package:flower_app/features/edit_address/domain/use_cases/edit_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_address_use_case_test.mocks.dart';

@GenerateMocks([EditAddressRepoContract])
void main() {
  late MockEditAddressRepoContract repoContract;
  late EditAddressUseCase useCase;

  final request = AddAddressDto(
    street: 'Ahmed',
    phone: '0102419753',
    city: 'cairo',
    lat: '30.08525452318584',
    long: '31.282610287469513',
    username: 'ahmed',
  );

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse<List<AddressEntity>>(data: [AddressEntity()]),
    );
    provideDummy<BaseResponse<List<AddressEntity>>>(
      ErrorBaseResponse<List<AddressEntity>>(exception: Exception()),
    );
  });

  setUp(() {
    repoContract = MockEditAddressRepoContract();
    useCase = EditAddressUseCase(repoContract);
  });

  group('EditAddressUseCase', () {
    test('returns success response when repository succeeds', () async {
      final entities = [AddressEntity(id: '1')];

      when(repoContract.editAddress(id: '1', request: request)).thenAnswer(
        (_) async => SuccessBaseResponse<List<AddressEntity>>(data: entities),
      );

      final result = await useCase(id: '1', request: request);

      expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
      expect((result as SuccessBaseResponse<List<AddressEntity>>).data, entities);

      verify(repoContract.editAddress(id: '1', request: request)).called(1);
      verifyNoMoreInteractions(repoContract);
    });

    test('returns error response when repository fails', () async {
      final exception = Exception();

      when(repoContract.editAddress(id: '1', request: request)).thenAnswer(
        (_) async => ErrorBaseResponse<List<AddressEntity>>(exception: exception),
      );

      final result = await useCase(id: '1', request: request);

      expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
      expect((result as ErrorBaseResponse<List<AddressEntity>>).exception, exception);

      verify(repoContract.editAddress(id: '1', request: request)).called(1);
      verifyNoMoreInteractions(repoContract);
    });
  });
}

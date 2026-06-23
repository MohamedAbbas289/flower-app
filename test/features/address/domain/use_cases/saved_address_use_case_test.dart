import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/saved_address/domain/repositories_contract/saved_address_repo_contract.dart';
import 'package:flower_app/features/saved_address/domain/use_cases/saved_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_address_use_case_test.mocks.dart';

@GenerateMocks([SavedAddressRepoContract])
void main() {
  late MockSavedAddressRepoContract repoContract;
  late GetAddressesUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse<List<AddressEntity>>(data: [AddressEntity()]),
    );
    provideDummy<BaseResponse<List<AddressEntity>>>(
      ErrorBaseResponse<List<AddressEntity>>(exception: Exception()),
    );
  });

  setUp(() {
    repoContract = MockSavedAddressRepoContract();
    useCase = GetAddressesUseCase(repoContract);
  });

  group('GetAddressesUseCase', () {
    test('returns success response when repository succeeds', () async {
      final addresses = [AddressEntity(id: '1')];

      when(repoContract.getAddresses()).thenAnswer(
        (_) async => SuccessBaseResponse<List<AddressEntity>>(data: addresses),
      );

      final result = await useCase();

      expect(result, isA<SuccessBaseResponse<List<AddressEntity>>>());
      expect((result as SuccessBaseResponse<List<AddressEntity>>).data, addresses);

      verify(repoContract.getAddresses()).called(1);
      verifyNoMoreInteractions(repoContract);
    });

    test('returns error response when repository fails', () async {
      final exception = Exception();

      when(repoContract.getAddresses()).thenAnswer(
        (_) async => ErrorBaseResponse<List<AddressEntity>>(exception: exception),
      );

      final result = await useCase();

      expect(result, isA<ErrorBaseResponse<List<AddressEntity>>>());
      expect((result as ErrorBaseResponse<List<AddressEntity>>).exception, exception);

      verify(repoContract.getAddresses()).called(1);
      verifyNoMoreInteractions(repoContract);
    });
  });
}

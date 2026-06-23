import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/domain/repository_contract/address_repository_contract.dart';
import 'package:flower_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_address_use_case_test.mocks.dart';

@GenerateMocks([AddressRepositoryContract])
void main() {
  late MockAddressRepositoryContract repoContract;
  late DeleteAddressUseCase useCase;

  setUpAll(() {
    provideDummy<BaseResponse<bool>>(SuccessBaseResponse<bool>(data: true));
    provideDummy<BaseResponse<bool>>(ErrorBaseResponse<bool>(exception: Exception()));
  });

  setUp(() {
    repoContract = MockAddressRepositoryContract();
    useCase = DeleteAddressUseCase(repoContract);
  });

  group('DeleteAddressUseCase', () {
    test('returns success response when repository succeeds', () async {
      when(repoContract.deleteAddress('1')).thenAnswer(
        (_) async => SuccessBaseResponse<bool>(data: true),
      );

      final dynamic result = await useCase('1');

      expect(result, isA<SuccessBaseResponse<bool>>());
      expect((result as SuccessBaseResponse<bool>).data, true);

      verify(repoContract.deleteAddress('1')).called(1);
      verifyNoMoreInteractions(repoContract);
    });

    test('returns error response when repository fails', () async {
      final exception = Exception();

      when(repoContract.deleteAddress('1')).thenAnswer(
        (_) async => ErrorBaseResponse<bool>(exception: exception),
      );

      final dynamic result = await useCase('1');

      expect(result, isA<ErrorBaseResponse<bool>>());
      expect((result as ErrorBaseResponse<bool>).exception, exception);

      verify(repoContract.deleteAddress('1')).called(1);
      verifyNoMoreInteractions(repoContract);
    });
  });
}

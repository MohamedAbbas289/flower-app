import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/firebase/last_address_firestore_service.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/add_address_use_cases.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_cubit.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_events.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_addres_view_model_test.mocks.dart';

@GenerateMocks([AddAddressUseCases, LastAddressFirestoreService])
void main() {
  late MockAddAddressUseCases addAddressUseCases;
  late MockLastAddressFirestoreService lastAddressFirestoreService;
  late AddAddressCubit cubit;

  final request = AddAddressDto(
    id: '1',
    street: 'shalpy',
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
    addAddressUseCases = MockAddAddressUseCases();
    lastAddressFirestoreService = MockLastAddressFirestoreService();
    when(lastAddressFirestoreService.saveLastAddress(any)).thenAnswer(
      (_) async {},
    );
    cubit = AddAddressCubit(addAddressUseCases, lastAddressFirestoreService);
  });

  tearDown(() {
    cubit.close();
  });

  group('AddAddressCubit', () {
    test('emits loading then success when use case succeeds', () async {
      final entities = [AddressEntity()];

      when(addAddressUseCases(request)).thenAnswer(
        (_) async => SuccessBaseResponse<List<AddressEntity>>(data: entities),
      );

      cubit.doEvent(AddAddressDataEvent(request));

      await untilCalled(addAddressUseCases(request));

      expect(
        cubit.state.addAddressState.data,
        entities,
      );

      verify(addAddressUseCases(request)).called(1);
      verifyNoMoreInteractions(addAddressUseCases);
    });

    test('emits loading then error when use case fails', () async {
      final exception = Exception('error');

      when(addAddressUseCases(request)).thenAnswer(
        (_) async => ErrorBaseResponse<List<AddressEntity>>(exception: exception),
      );

      cubit.doEvent(AddAddressDataEvent(request));

      await untilCalled(addAddressUseCases(request));

      expect(cubit.state.addAddressState.msg, isNotNull);

      verify(addAddressUseCases(request)).called(1);
      verifyNoMoreInteractions(addAddressUseCases);
    });
  });
}
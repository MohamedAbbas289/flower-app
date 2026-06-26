import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/config/firebase/last_address_firestore_service.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/add_address_use_case.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_events.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_states.dart';
import 'package:flower_app/features/address/presentation/view_models/add_address_view_model/add_address_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_addres_view_model_test.mocks.dart';

@GenerateMocks([AddAddressUseCase, LastAddressFirestoreService])
void main() {
  late MockAddAddressUseCase addAddressUseCase;
  late MockLastAddressFirestoreService lastAddressFirestoreService;

  final request = AddAddressRequestModel(
    street: 'shalpy',
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
    addAddressUseCase = MockAddAddressUseCase();
    lastAddressFirestoreService = MockLastAddressFirestoreService();
    when(lastAddressFirestoreService.saveLastAddress(any)).thenAnswer(
      (_) async {},
    );
  });

  AddAddressViewModel buildViewModel() =>
      AddAddressViewModel(addAddressUseCase, lastAddressFirestoreService);

  group('AddAddressViewModel', () {
    blocTest<AddAddressViewModel, AddAddressStates>(
      'emits loading then success when use case succeeds',
      build: () {
        when(addAddressUseCase.execute(request: request)).thenAnswer(
          (_) async => SuccessBaseResponse<List<AddressEntity>>(
            data: const [AddressEntity(id: '1')],
          ),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(AddAddressDataEvent(request)),
      expect: () => [
        const AddAddressStates(
          addAddressState: BaseState<List<AddressEntity>>(isLoading: true),
        ),
        AddAddressStates(
          addAddressState: BaseState<List<AddressEntity>>.success(
            const [AddressEntity(id: '1')],
          ),
        ),
      ],
      verify: (_) {
        verify(addAddressUseCase.execute(request: request)).called(1);
        verify(
          lastAddressFirestoreService.saveLastAddress(
            const AddressEntity(id: '1'),
          ),
        ).called(1);
        verifyNoMoreInteractions(addAddressUseCase);
      },
    );

    blocTest<AddAddressViewModel, AddAddressStates>(
      'emits loading then error when use case fails',
      build: () {
        when(addAddressUseCase.execute(request: request)).thenAnswer(
          (_) async =>
              ErrorBaseResponse<List<AddressEntity>>(exception: Exception()),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(AddAddressDataEvent(request)),
      expect: () => [
        const AddAddressStates(
          addAddressState: BaseState<List<AddressEntity>>(isLoading: true),
        ),
        AddAddressStates(
          addAddressState: BaseState<List<AddressEntity>>.error(
            'somethingWentWrong',
          ),
        ),
      ],
      verify: (_) {
        verify(addAddressUseCase.execute(request: request)).called(1);
        verifyNoMoreInteractions(addAddressUseCase);
      },
    );
  });
}

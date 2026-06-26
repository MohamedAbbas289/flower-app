import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/saved_address_use_case.dart';
import 'package:flower_app/features/address/presentation/view_models/saved_address_view_model/saved_address_view_model.dart';
import 'package:flower_app/features/address/presentation/view_models/saved_address_view_model/saved_address_events.dart';
import 'package:flower_app/features/address/presentation/view_models/saved_address_view_model/saved_address_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_address_view_model_test.mocks.dart';

@GenerateMocks([GetAddressesUseCase, DeleteAddressUseCase])
void main() {
  late MockGetAddressesUseCase getAddressesUseCase;
  late MockDeleteAddressUseCase deleteAddressUseCase;

  const tAddress1 = AddressEntity(id: '1', street: 'Street 1', city: 'City 1');
  const tAddress2 = AddressEntity(id: '2', street: 'Street 2', city: 'City 2');

  setUpAll(() {
    provideDummy<BaseResponse<List<AddressEntity>>>(
      SuccessBaseResponse<List<AddressEntity>>(data: const []),
    );
    provideDummy<BaseResponse<List<AddressEntity>>>(
      ErrorBaseResponse<List<AddressEntity>>(exception: Exception()),
    );
    provideDummy<BaseResponse<bool>>(SuccessBaseResponse<bool>(data: true));
    provideDummy<BaseResponse<bool>>(ErrorBaseResponse<bool>(exception: Exception()));
  });

  setUp(() {
    getAddressesUseCase = MockGetAddressesUseCase();
    deleteAddressUseCase = MockDeleteAddressUseCase();
  });

  SavedAddressViewModel buildViewModel() =>
      SavedAddressViewModel(getAddressesUseCase, deleteAddressUseCase);

  group('SavedAddressViewModel - LoadAddressesEvent', () {
    blocTest<SavedAddressViewModel, SavedAddressStates>(
      'emits loading then success with the loaded addresses',
      build: () {
        when(getAddressesUseCase.execute()).thenAnswer(
          (_) async => SuccessBaseResponse<List<AddressEntity>>(
            data: const [tAddress1, tAddress2],
          ),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(const LoadAddressesEvent()),
      expect: () => [
        const SavedAddressStates(
          getAddressesState: BaseState<List<AddressEntity>>(isLoading: true),
        ),
        SavedAddressStates(
          getAddressesState: BaseState<List<AddressEntity>>.success(
            const [tAddress1, tAddress2],
          ),
        ),
      ],
      verify: (_) {
        verify(getAddressesUseCase.execute()).called(1);
        verifyNoMoreInteractions(getAddressesUseCase);
      },
    );

    blocTest<SavedAddressViewModel, SavedAddressStates>(
      'emits loading then error when use case fails',
      build: () {
        when(getAddressesUseCase.execute()).thenAnswer(
          (_) async => ErrorBaseResponse<List<AddressEntity>>(exception: Exception()),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(const LoadAddressesEvent()),
      expect: () => [
        const SavedAddressStates(
          getAddressesState: BaseState<List<AddressEntity>>(isLoading: true),
        ),
        SavedAddressStates(
          getAddressesState: BaseState<List<AddressEntity>>.error('somethingWentWrong'),
        ),
      ],
      verify: (_) {
        verify(getAddressesUseCase.execute()).called(1);
        verifyNoMoreInteractions(getAddressesUseCase);
      },
    );
  });

  group('SavedAddressViewModel - DeleteAddressEvent', () {
    blocTest<SavedAddressViewModel, SavedAddressStates>(
      'removes the deleted address from getAddressesState on success',
      seed: () => SavedAddressStates(
        getAddressesState: BaseState<List<AddressEntity>>.success(
          const [tAddress1, tAddress2],
        ),
      ),
      build: () {
        when(deleteAddressUseCase.execute(id: '1')).thenAnswer(
          (_) async => SuccessBaseResponse<bool>(data: true),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(const DeleteAddressEvent('1')),
      expect: () => [
        SavedAddressStates(
          getAddressesState: BaseState<List<AddressEntity>>.success(
            const [tAddress1, tAddress2],
          ),
          deleteAddressState: BaseState<bool>.loading(),
        ),
        SavedAddressStates(
          getAddressesState: BaseState<List<AddressEntity>>.success(
            const [tAddress2],
          ),
          deleteAddressState: BaseState<bool>.success(true),
        ),
      ],
      verify: (_) {
        verify(deleteAddressUseCase.execute(id: '1')).called(1);
        verifyNoMoreInteractions(deleteAddressUseCase);
      },
    );

    blocTest<SavedAddressViewModel, SavedAddressStates>(
      'emits error state when delete use case fails',
      build: () {
        when(deleteAddressUseCase.execute(id: '1')).thenAnswer(
          (_) async => ErrorBaseResponse<bool>(exception: Exception()),
        );
        return buildViewModel();
      },
      act: (cubit) => cubit.doEvent(const DeleteAddressEvent('1')),
      expect: () => [
        const SavedAddressStates(
          deleteAddressState: BaseState<bool>(isLoading: true),
        ),
        SavedAddressStates(
          deleteAddressState: BaseState<bool>.error('somethingWentWrong'),
        ),
      ],
      verify: (_) {
        verify(deleteAddressUseCase.execute(id: '1')).called(1);
        verifyNoMoreInteractions(deleteAddressUseCase);
      },
    );
  });
}

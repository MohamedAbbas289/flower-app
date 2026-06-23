import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/edit_address_use_case.dart';
import 'package:flower_app/features/address/presentation/view_models/edit_address_view_model/edit_address_view_model.dart';
import 'package:flower_app/features/address/presentation/view_models/edit_address_view_model/edit_address_event.dart';
import 'package:flower_app/features/address/presentation/view_models/edit_address_view_model/edit_address_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_address_view_model_test.mocks.dart';

@GenerateMocks([EditAddressUseCase])
void main() {
  late MockEditAddressUseCase editAddressUseCase;

  final request = AddAddressDto(
    id: '1',
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
    editAddressUseCase = MockEditAddressUseCase();
  });

  group('EditAddressViewModel', () {
    blocTest<EditAddressViewModel, EditAddressStates>(
      'emits loading then success when use case succeeds',
      build: () {
        when(editAddressUseCase(id: '1', request: request)).thenAnswer(
          (_) async => SuccessBaseResponse<List<AddressEntity>>(
            data: [AddressEntity(id: '1')],
          ),
        );
        return EditAddressViewModel(editAddressUseCase);
      },
      act: (cubit) => cubit.doEvent(
        SubmitEditAddressEvent(id: '1', request: request),
      ),
      expect: () => [
        const EditAddressStates(
          editAddressState: BaseState<List<AddressEntity>>(isLoading: true),
        ),
        EditAddressStates(
          editAddressState: BaseState<List<AddressEntity>>.success(
            [AddressEntity(id: '1')],
          ),
        ),
      ],
      verify: (_) {
        verify(editAddressUseCase(id: '1', request: request)).called(1);
        verifyNoMoreInteractions(editAddressUseCase);
      },
    );

    blocTest<EditAddressViewModel, EditAddressStates>(
      'emits loading then error when use case fails',
      build: () {
        when(editAddressUseCase(id: '1', request: request)).thenAnswer(
          (_) async => ErrorBaseResponse<List<AddressEntity>>(exception: Exception()),
        );
        return EditAddressViewModel(editAddressUseCase);
      },
      act: (cubit) => cubit.doEvent(
        SubmitEditAddressEvent(id: '1', request: request),
      ),
      expect: () => [
        const EditAddressStates(
          editAddressState: BaseState<List<AddressEntity>>(isLoading: true),
        ),
        EditAddressStates(
          editAddressState: BaseState<List<AddressEntity>>.error('somethingWentWrong'),
        ),
      ],
      verify: (_) {
        verify(editAddressUseCase(id: '1', request: request)).called(1);
        verifyNoMoreInteractions(editAddressUseCase);
      },
    );
  });
}

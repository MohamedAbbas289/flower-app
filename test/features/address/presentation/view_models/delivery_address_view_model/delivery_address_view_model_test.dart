import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/address/domain/display_states/delivery_address_display.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/resolve_delivery_address_use_case.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_events.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_state.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delivery_address_view_model_test.mocks.dart';

@GenerateMocks([ResolveDeliveryAddressUseCase])
void main() {
  late MockResolveDeliveryAddressUseCase resolveDeliveryAddressUseCase;

  const tAddress = AddressEntity(
    id: '1',
    street: 'Street 1',
    city: 'City 1',
    lat: '30.0',
    long: '31.0',
  );

  DeliveryAddressViewModel buildViewModel() =>
      DeliveryAddressViewModel(resolveDeliveryAddressUseCase);

  setUpAll(() {
    provideDummy<DeliveryAddressDisplayState>(const NoAddressDisplay());
  });

  setUp(() {
    resolveDeliveryAddressUseCase = MockResolveDeliveryAddressUseCase();
  });

  group('DeliveryAddressViewModel - initial state', () {
    test('state is DeliveryAddressState() with idle BaseState', () {
      final vm = buildViewModel();
      expect(vm.state, const DeliveryAddressState());
      vm.close();
    });
  });

  group('DeliveryAddressViewModel - LoadDeliveryAddressEvent', () {
    blocTest<DeliveryAddressViewModel, DeliveryAddressState>(
      'emits loading then success with NoAddressDisplay',
      build: () {
        when(
          resolveDeliveryAddressUseCase.execute(),
        ).thenAnswer((_) async => const NoAddressDisplay());
        return buildViewModel();
      },
      act: (vm) => vm.doEvent(const LoadDeliveryAddressEvent()),
      expect: () => [
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplayState>(
            isLoading: true,
          ),
        ),
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplayState>(
            data: NoAddressDisplay(),
          ),
        ),
      ],
      verify: (_) {
        verify(resolveDeliveryAddressUseCase.execute()).called(1);
        verifyNoMoreInteractions(resolveDeliveryAddressUseCase);
      },
    );

    blocTest<DeliveryAddressViewModel, DeliveryAddressState>(
      'emits loading then success with the resolved SavedAddressDisplay',
      build: () {
        when(resolveDeliveryAddressUseCase.execute()).thenAnswer(
          (_) async => const SavedAddressDisplay(tAddress, isNearest: true),
        );
        return buildViewModel();
      },
      act: (vm) => vm.doEvent(const LoadDeliveryAddressEvent()),
      expect: () => [
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplayState>(
            isLoading: true,
          ),
        ),
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplayState>(
            data: SavedAddressDisplay(tAddress, isNearest: true),
          ),
        ),
      ],
      verify: (_) {
        verify(resolveDeliveryAddressUseCase.execute()).called(1);
        verifyNoMoreInteractions(resolveDeliveryAddressUseCase);
      },
    );

    blocTest<DeliveryAddressViewModel, DeliveryAddressState>(
      'emits loading then success with CurrentLocationDisplay',
      build: () {
        when(resolveDeliveryAddressUseCase.execute()).thenAnswer(
          (_) async => const CurrentLocationDisplay('Some Area, City'),
        );
        return buildViewModel();
      },
      act: (vm) => vm.doEvent(const LoadDeliveryAddressEvent()),
      expect: () => [
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplayState>(
            isLoading: true,
          ),
        ),
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplayState>(
            data: CurrentLocationDisplay('Some Area, City'),
          ),
        ),
      ],
      verify: (_) {
        verify(resolveDeliveryAddressUseCase.execute()).called(1);
        verifyNoMoreInteractions(resolveDeliveryAddressUseCase);
      },
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/entities/delivery_address_display.dart';
import 'package:flower_app/features/address/domain/use_cases/resolve_delivery_address_use_case.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_view_model.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_events.dart';
import 'package:flower_app/features/address/presentation/view_models/delivery_address_view_model/delivery_address_state.dart';
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
    provideDummy<DeliveryAddressDisplay>(const NoAddressDisplay());
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
          resolveDeliveryAddressUseCase(),
        ).thenAnswer((_) async => const NoAddressDisplay());
        return buildViewModel();
      },
      act: (vm) => vm.doEvent(const LoadDeliveryAddressEvent()),
      expect: () => [
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplay>(
            isLoading: true,
          ),
        ),
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplay>(
            data: NoAddressDisplay(),
          ),
        ),
      ],
    );

    blocTest<DeliveryAddressViewModel, DeliveryAddressState>(
      'emits loading then success with the resolved SavedAddressDisplay',
      build: () {
        when(resolveDeliveryAddressUseCase()).thenAnswer(
          (_) async => const SavedAddressDisplay(tAddress, isNearest: true),
        );
        return buildViewModel();
      },
      act: (vm) => vm.doEvent(const LoadDeliveryAddressEvent()),
      expect: () => [
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplay>(
            isLoading: true,
          ),
        ),
        const DeliveryAddressState(
          deliveryAddressState: BaseState<DeliveryAddressDisplay>(
            data: SavedAddressDisplay(tAddress, isNearest: true),
          ),
        ),
      ],
    );
  });
}

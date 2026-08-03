import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/features/shopping/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/watch_order_use_case.dart';
import 'package:flower_app/features/shopping/presentation/view_models/track_order_view_model/track_order_event.dart';
import 'package:flower_app/features/shopping/presentation/view_models/track_order_view_model/track_order_state.dart';
import 'package:flower_app/features/shopping/presentation/view_models/track_order_view_model/track_order_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'track_order_view_model_test.mocks.dart';

@GenerateMocks([WatchOrderUseCase, ConfirmDeliveryUseCase, DocumentSnapshot])
void main() {
  late MockWatchOrderUseCase mockWatchOrderUseCase;
  late MockConfirmDeliveryUseCase mockConfirmDeliveryUseCase;
  late TrackOrderViewModel viewModel;

  const orderId = 'order123';

  setUp(() {
    mockWatchOrderUseCase = MockWatchOrderUseCase();
    mockConfirmDeliveryUseCase = MockConfirmDeliveryUseCase();
  });

  tearDown(() {
    viewModel.close();
  });

  StreamController<DocumentSnapshot> controllerWithSnapshot(
    Map<String, dynamic> data,
  ) {
    final snapshot = MockDocumentSnapshot();
    when(snapshot.exists).thenReturn(true);
    when(snapshot.data()).thenReturn(data);
    late final StreamController<DocumentSnapshot> controller;
    controller = StreamController<DocumentSnapshot>.broadcast(
      onListen: () => controller.add(snapshot),
    );
    return controller;
  }

  group('TrackOrderViewModel', () {
    test('initial state is loading', () {
      when(mockWatchOrderUseCase.execute(any))
          .thenAnswer((_) => const Stream.empty());
      viewModel = TrackOrderViewModel(
        mockWatchOrderUseCase,
        mockConfirmDeliveryUseCase,
      );
      expect(viewModel.state, const TrackOrderState(isLoading: true));
    });

    blocTest<TrackOrderViewModel, TrackOrderState>(
      'emits updated state when Firestore snapshot arrives — accepted',
      build: () {
        final controller = controllerWithSnapshot({
          'status': 'accepted',
          'driverName': 'Ahmed',
          'driverPhone': '01012345678',
          'userConfirmed': false,
        });
        when(mockWatchOrderUseCase.execute(orderId))
            .thenAnswer((_) => controller.stream);
        final vm = TrackOrderViewModel(
          mockWatchOrderUseCase,
          mockConfirmDeliveryUseCase,
        );
        addTearDown(() => controller.close());
        return vm;
      },
      act: (vm) => vm.add(StartListeningEvent(orderId)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const TrackOrderState(
          status: 'accepted',
          driverName: 'Ahmed',
          driverPhone: '01012345678',
          userConfirmed: false,
          stepsCompleted: 1,
          isLoading: false,
        ),
      ],
    );

    blocTest<TrackOrderViewModel, TrackOrderState>(
      'maps arrived_pickup to stepsCompleted=2',
      build: () {
        final controller = controllerWithSnapshot({
          'status': 'arrived_pickup',
          'driverName': 'Mohamed',
          'driverPhone': '01099999999',
          'userConfirmed': false,
        });
        when(mockWatchOrderUseCase.execute(orderId))
            .thenAnswer((_) => controller.stream);
        final vm = TrackOrderViewModel(
          mockWatchOrderUseCase,
          mockConfirmDeliveryUseCase,
        );
        addTearDown(() => controller.close());
        return vm;
      },
      act: (vm) => vm.add(StartListeningEvent(orderId)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<TrackOrderState>()
            .having((s) => s.stepsCompleted, 'stepsCompleted', 2)
            .having((s) => s.status, 'status', 'arrived_pickup'),
      ],
    );

    blocTest<TrackOrderViewModel, TrackOrderState>(
      'maps out_for_delivery to stepsCompleted=3',
      build: () {
        final controller = controllerWithSnapshot({
          'status': 'out_for_delivery',
          'driverName': 'Ali',
          'driverPhone': '01011111111',
          'userConfirmed': false,
        });
        when(mockWatchOrderUseCase.execute(orderId))
            .thenAnswer((_) => controller.stream);
        final vm = TrackOrderViewModel(
          mockWatchOrderUseCase,
          mockConfirmDeliveryUseCase,
        );
        addTearDown(() => controller.close());
        return vm;
      },
      act: (vm) => vm.add(StartListeningEvent(orderId)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<TrackOrderState>()
            .having((s) => s.stepsCompleted, 'stepsCompleted', 3),
      ],
    );

    blocTest<TrackOrderViewModel, TrackOrderState>(
      'maps arrived_user to stepsCompleted=4 and showConfirmButton=true',
      build: () {
        final controller = controllerWithSnapshot({
          'status': 'arrived_user',
          'driverName': 'Khaled',
          'driverPhone': '01022222222',
          'userConfirmed': false,
        });
        when(mockWatchOrderUseCase.execute(orderId))
            .thenAnswer((_) => controller.stream);
        final vm = TrackOrderViewModel(
          mockWatchOrderUseCase,
          mockConfirmDeliveryUseCase,
        );
        addTearDown(() => controller.close());
        return vm;
      },
      act: (vm) => vm.add(StartListeningEvent(orderId)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<TrackOrderState>()
            .having((s) => s.stepsCompleted, 'stepsCompleted', 4)
            .having((s) => s.showConfirmButton, 'showConfirmButton', true),
      ],
    );

    blocTest<TrackOrderViewModel, TrackOrderState>(
      'ConfirmDeliveryEvent calls ConfirmDeliveryUseCase and sets userConfirmed=true',
      build: () {
        when(mockWatchOrderUseCase.execute(orderId))
            .thenAnswer((_) => const Stream.empty());
        when(mockConfirmDeliveryUseCase.execute(orderId))
            .thenAnswer((_) async {});
        return TrackOrderViewModel(
          mockWatchOrderUseCase,
          mockConfirmDeliveryUseCase,
        );
      },
      seed: () => const TrackOrderState(
        status: 'arrived_user',
        stepsCompleted: 4,
        userConfirmed: false,
        isLoading: false,
      ),
      act: (vm) => vm.add(ConfirmDeliveryEvent(orderId)),
      expect: () => [
        isA<TrackOrderState>()
            .having((s) => s.userConfirmed, 'userConfirmed', false)
            .having(
              (s) => s.confirmDeliveryState.isLoading,
              'confirmDeliveryState.isLoading',
              true,
            ),
        isA<TrackOrderState>()
            .having((s) => s.userConfirmed, 'userConfirmed', true)
            .having(
              (s) => s.confirmDeliveryState.isLoading,
              'confirmDeliveryState.isLoading',
              false,
            ),
      ],
      verify: (_) {
        verify(mockConfirmDeliveryUseCase.execute(orderId)).called(1);
      },
    );

    blocTest<TrackOrderViewModel, TrackOrderState>(
      'userConfirmed=true means showConfirmButton=false',
      build: () {
        final controller = controllerWithSnapshot({
          'status': 'delivered',
          'driverName': 'Omar',
          'driverPhone': '01033333333',
          'userConfirmed': true,
        });
        when(mockWatchOrderUseCase.execute(orderId))
            .thenAnswer((_) => controller.stream);
        final vm = TrackOrderViewModel(
          mockWatchOrderUseCase,
          mockConfirmDeliveryUseCase,
        );
        addTearDown(() => controller.close());
        return vm;
      },
      act: (vm) => vm.add(StartListeningEvent(orderId)),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<TrackOrderState>()
            .having((s) => s.userConfirmed, 'userConfirmed', true)
            .having((s) => s.showConfirmButton, 'showConfirmButton', false),
      ],
    );

    test('unknown status maps to stepsCompleted=0', () {
      when(mockWatchOrderUseCase.execute(any))
          .thenAnswer((_) => const Stream.empty());
      viewModel = TrackOrderViewModel(
        mockWatchOrderUseCase,
        mockConfirmDeliveryUseCase,
      );
      viewModel.add(
        OrderUpdatedEvent(
          status: 'unknown_status',
          driverName: '',
          driverPhone: '',
          userConfirmed: false,
        ),
      );
      expect(viewModel.state.stepsCompleted, 0);
    });
  });
}

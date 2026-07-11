import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/core/utils/osrm_route_service.dart';
import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';
import 'package:flower_app/features/shopping/domain/entities/route_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:flower_app/features/shopping/presentation/view_models/buyer_map_cubit/buyer_map_cubit.dart';
import 'package:flower_app/features/shopping/presentation/view_models/buyer_map_cubit/buyer_map_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'buyer_map_cubit_test.mocks.dart';

@GenerateMocks([ShoppingRepositoryContract, OsrmRouteService])
void main() {
  late MockShoppingRepositoryContract mockRepo;
  late MockOsrmRouteService mockOsrm;
  late StreamController<LatLngPoint> driverController;
  late StreamController<LatLngPoint> destinationController;

  const destination = LatLngPoint(lat: 30.0, lng: 31.0);
  const tRoute = RouteEntity(
    waypoints: [],
    distanceMeters: 100,
    durationSeconds: 60,
  );

  setUp(() {
    mockRepo = MockShoppingRepositoryContract();
    mockOsrm = MockOsrmRouteService();
    driverController = StreamController<LatLngPoint>();
    destinationController = StreamController<LatLngPoint>();

    when(mockRepo.watchDriverLocation(any))
        .thenAnswer((_) => driverController.stream);
    when(mockRepo.watchDestinationLocation(any))
        .thenAnswer((_) => destinationController.stream);
    when(mockOsrm.getRoute(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).thenAnswer((_) async => tRoute);
  });

  tearDown(() async {
    if (!driverController.isClosed) await driverController.close();
    if (!destinationController.isClosed) await destinationController.close();
  });

  BuyerMapCubit buildCubit() => BuyerMapCubit(mockRepo, mockOsrm);

  test('initial state is loading', () {
    final cubit = buildCubit();

    expect(cubit.state, const BuyerMapState());
    expect(cubit.state.phase, BuyerMapPhase.loading);
  });

  test('init subscribes to repo.watchDriverLocation', () {
    final cubit = buildCubit();

    cubit.init(orderId: 'order_1', destination: destination);

    verify(mockRepo.watchDriverLocation('order_1')).called(1);
    cubit.close();
  });

  test('init subscribes to repo.watchDestinationLocation when no destination',
      () {
    final cubit = buildCubit();

    cubit.init(orderId: 'order_1');

    verify(mockRepo.watchDestinationLocation('order_1')).called(1);
    cubit.close();
  });

  blocTest<BuyerMapCubit, BuyerMapState>(
    'emits ready with driverLocation when a driver location is received',
    build: buildCubit,
    act: (cubit) async {
      cubit.init(orderId: 'order_1', destination: destination);
      driverController.add(const LatLngPoint(lat: 30.001, lng: 31.001));
      await Future.delayed(const Duration(milliseconds: 50));
    },
    expect: () => [
      isA<BuyerMapState>()
          .having((s) => s.destination, 'destination', same(destination)),
      isA<BuyerMapState>()
          .having((s) => s.phase, 'phase', BuyerMapPhase.ready)
          .having((s) => s.driverLocation, 'driverLocation', isNotNull),
      isA<BuyerMapState>().having((s) => s.route, 'route', same(tRoute)),
    ],
  );

  test('fetches route on the first driver location update', () async {
    final cubit = buildCubit();
    cubit.init(orderId: 'order_1', destination: destination);

    driverController.add(const LatLngPoint(lat: 30.001, lng: 31.001));
    await Future.delayed(const Duration(milliseconds: 50));

    verify(mockOsrm.getRoute(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).called(1);

    await cubit.close();
  });

  test('does not refetch route when driver moves less than 30m', () async {
    final cubit = buildCubit();
    cubit.init(orderId: 'order_1', destination: destination);

    driverController.add(const LatLngPoint(lat: 30.1, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 50));
    driverController.add(const LatLngPoint(lat: 30.1001, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 50));

    verify(mockOsrm.getRoute(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).called(1);

    await cubit.close();
  });

  test('refetches route when driver moves more than 30m', () async {
    final cubit = buildCubit();
    cubit.init(orderId: 'order_1', destination: destination);

    driverController.add(const LatLngPoint(lat: 30.1, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 50));
    driverController.add(const LatLngPoint(lat: 30.2, lng: 31.1));
    await Future.delayed(const Duration(milliseconds: 50));

    verify(mockOsrm.getRoute(
      origin: anyNamed('origin'),
      destination: anyNamed('destination'),
    )).called(2);

    await cubit.close();
  });

  test('close cancels subscriptions without throwing', () async {
    final cubit = buildCubit();
    cubit.init(orderId: 'order_1');

    expect(driverController.hasListener, isTrue);
    expect(destinationController.hasListener, isTrue);

    await expectLater(cubit.close(), completes);

    expect(driverController.hasListener, isFalse);
    expect(destinationController.hasListener, isFalse);
  });
}

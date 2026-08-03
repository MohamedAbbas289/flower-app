import 'package:equatable/equatable.dart';
import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';
import 'package:flower_app/features/shopping/domain/entities/route_entity.dart';

enum BuyerMapPhase { loading, ready, timeout }

class BuyerMapState extends Equatable {
  final BuyerMapPhase phase;
  final LatLngPoint? driverLocation;
  final LatLngPoint? destination;
  final RouteEntity? route;

  const BuyerMapState({
    this.phase = BuyerMapPhase.loading,
    this.driverLocation,
    this.destination,
    this.route,
  });

  BuyerMapState copyWith({
    BuyerMapPhase? phase,
    LatLngPoint? driverLocation,
    LatLngPoint? destination,
    RouteEntity? route,
  }) => BuyerMapState(
    phase: phase ?? this.phase,
    driverLocation: driverLocation ?? this.driverLocation,
    destination: destination ?? this.destination,
    route: route ?? this.route,
  );

  @override
  List<Object?> get props => [phase, driverLocation, destination, route];
}

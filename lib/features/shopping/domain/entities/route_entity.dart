import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';

class RouteEntity {
  final List<LatLngPoint> waypoints;
  final double distanceMeters;
  final double durationSeconds;
  const RouteEntity({
    required this.waypoints,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

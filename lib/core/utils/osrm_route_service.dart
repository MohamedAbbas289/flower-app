import 'package:dio/dio.dart';
import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';
import 'package:flower_app/features/shopping/domain/entities/route_entity.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class OsrmRouteService {
  final Dio _dio;
  OsrmRouteService(this._dio);

  Future<RouteEntity?> getRoute({
    required LatLngPoint origin,
    required LatLngPoint destination,
  }) async {
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/${origin.lng},${origin.lat};${destination.lng},${destination.lat}?overview=full&geometries=geojson';
      final response = await _dio.get<Map<String, dynamic>>(url);
      final routes = response.data?['routes'] as List?;
      if (routes == null || routes.isEmpty) return null;
      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>?;
      final coords = geometry?['coordinates'] as List? ?? [];
      return RouteEntity(
        waypoints: coords
            .map(
              (c) => LatLngPoint(
                lat: (c[1] as num).toDouble(),
                lng: (c[0] as num).toDouble(),
              ),
            )
            .toList(),
        distanceMeters: (route['distance'] as num?)?.toDouble() ?? 0,
        durationSeconds: (route['duration'] as num?)?.toDouble() ?? 0,
      );
    } catch (_) {
      return null;
    }
  }
}

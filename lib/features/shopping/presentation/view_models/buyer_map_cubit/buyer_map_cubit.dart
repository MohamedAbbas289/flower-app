import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flower_app/core/utils/osrm_route_service.dart';
import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:flower_app/features/shopping/presentation/view_models/buyer_map_cubit/buyer_map_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@injectable
class BuyerMapCubit extends Cubit<BuyerMapState> {
  final ShoppingRepositoryContract _repo;
  final OsrmRouteService _osrm;

  BuyerMapCubit(this._repo, this._osrm) : super(const BuyerMapState());

  StreamSubscription<LatLngPoint>? _locationSub;
  Timer? _loadingTimer;
  LatLngPoint? _lastRouteOrigin;

  void init({required String orderId, LatLngPoint? destination}) {
    if (destination != null) {
      emit(state.copyWith(destination: destination));
    } else {
      _resolveDeviceLocation();
    }
    _loadingTimer = Timer(const Duration(seconds: 15), () {
      if (isClosed) return;
      if (state.driverLocation == null) {
        emit(state.copyWith(phase: BuyerMapPhase.timeout));
      }
    });
    _locationSub = _repo.watchDriverLocation(orderId).listen((point) {
      if (isClosed) return;
      _loadingTimer?.cancel();
      emit(state.copyWith(phase: BuyerMapPhase.ready, driverLocation: point));
      final shouldReroute =
          _lastRouteOrigin == null || _distance(point, _lastRouteOrigin!) > 30;
      if (shouldReroute) _refreshRoute();
    });
  }

  Future<void> _resolveDeviceLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          destination: LatLngPoint(
            lat: position.latitude,
            lng: position.longitude,
          ),
        ),
      );
      _refreshRoute();
    } catch (_) {}
  }

  Future<void> _refreshRoute() async {
    final driver = state.driverLocation;
    final destination = state.destination;
    if (driver == null || destination == null) return;
    _lastRouteOrigin = driver;
    final route = await _osrm.getRoute(
      origin: driver,
      destination: destination,
    );
    if (isClosed) return;
    emit(state.copyWith(route: route));
  }

  double _distance(LatLngPoint a, LatLngPoint b) {
    final dLat = (b.lat - a.lat) * pi / 180;
    final dLng = (b.lng - a.lng) * pi / 180;
    final x =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(a.lat * pi / 180) *
            cos(b.lat * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return 6371000 * 2 * atan2(sqrt(x), sqrt(1 - x));
  }

  @override
  Future<void> close() async {
    _loadingTimer?.cancel();
    await _locationSub?.cancel();
    return super.close();
  }
}

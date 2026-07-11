import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/core/values/firestore_keys.dart';
import 'package:flower_app/features/shopping/data/data_sources_contract/shopping_firestore_data_source_contract.dart';
import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ShoppingFirestoreDataSourceContract)
class ShoppingFirestoreDataSourceImpl
    implements ShoppingFirestoreDataSourceContract {
  final FirestoreService _firestoreService;

  ShoppingFirestoreDataSourceImpl(this._firestoreService);

  @override
  Stream<DocumentSnapshot> orderStream(String orderId) {
    return _firestoreService.orderStream(orderId);
  }

  @override
  Future<void> confirmDelivery(String orderId) {
    return _firestoreService.confirmDelivery(orderId);
  }

  @override
  Stream<LatLngPoint> watchDriverLocation(String orderId) {
    return _pointStream(
      orderId,
      latKey: FirestoreKeys.driverLat,
      lngKey: FirestoreKeys.driverLng,
    );
  }

  @override
  Stream<LatLngPoint> watchDestinationLocation(String orderId) {
    return _pointStream(
      orderId,
      latKey: FirestoreKeys.buyerLat,
      lngKey: FirestoreKeys.buyerLng,
    );
  }

  Stream<LatLngPoint> _pointStream(
    String orderId, {
    required String latKey,
    required String lngKey,
  }) {
    return _firestoreService
        .orderStream(orderId)
        .where(
          (snapshot) =>
              snapshot.exists &&
              (snapshot.data() as Map<String, dynamic>?)?[latKey] != null &&
              (snapshot.data() as Map<String, dynamic>?)?[lngKey] != null,
        )
        .map((snapshot) {
          final data = snapshot.data() as Map<String, dynamic>;
          return LatLngPoint(
            lat: (data[latKey] as num).toDouble(),
            lng: (data[lngKey] as num).toDouble(),
          );
        });
  }
}

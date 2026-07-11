import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/features/shopping/domain/entities/lat_lng_point.dart';

abstract interface class ShoppingFirestoreDataSourceContract {
  Stream<DocumentSnapshot> orderStream(String orderId);
  Future<void> confirmDelivery(String orderId);
  Stream<LatLngPoint> watchDriverLocation(String orderId);
  Stream<LatLngPoint> watchDestinationLocation(String orderId);
}

import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class ShoppingFirestoreDataSourceContract {
  Stream<DocumentSnapshot> orderStream(String orderId);
  Future<void> confirmDelivery(String orderId);
}

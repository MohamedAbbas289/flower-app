import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/core/values/firestore_keys.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Future<void> saveUserFcmData({
    required String userId,
    required String fcmToken,
    required String language,
  }) async {
    await _firestore
        .collection(FirestoreKeys.usersCollection)
        .doc(userId)
        .set(
          {
            FirestoreKeys.fcmToken: fcmToken,
            FirestoreKeys.language: language,
          },
          SetOptions(merge: true),
        );
  }

  Future<void> updateUserLanguage({
    required String userId,
    required String language,
  }) async {
    await _firestore
        .collection(FirestoreKeys.usersCollection)
        .doc(userId)
        .set(
          {FirestoreKeys.language: language},
          SetOptions(merge: true),
        );
  }

  Stream<DocumentSnapshot> orderStream(String orderId) {
    return _firestore
        .collection(FirestoreKeys.ordersCollection)
        .doc(orderId)
        .snapshots();
  }

  Future<void> confirmDelivery(String orderId) async {
    await _firestore
        .collection(FirestoreKeys.ordersCollection)
        .doc(orderId)
        .update({FirestoreKeys.userConfirmed: true});
  }
}

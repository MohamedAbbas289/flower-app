import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LastAddressFirestoreService {
  static const _collection = 'user_last_address';
  static const _timeout = Duration(seconds: 10);

  final FirebaseFirestore _firestore;
  final AuthManager _authManager;

  LastAddressFirestoreService(this._firestore, this._authManager);

  Future<void> saveLastAddress(AddressEntity address) async {
    final userId = _authManager.userId;
    if (userId == null || userId.isEmpty) return;

    try {
      final dto = AddAddressDto(
        street: address.street,
        phone: address.phone,
        city: address.city,
        lat: address.lat,
        long: address.long,
        username: address.username,
        id: address.id,
      );

      await _firestore
          .collection(_collection)
          .doc(userId)
          .set(dto.toJson(), SetOptions(merge: true))
          .timeout(_timeout);
    } catch (_) {}
  }

  Future<AddressEntity?> getLastAddress() async {
    final userId = _authManager.userId;
    if (userId == null || userId.isEmpty) return null;

    try {
      final snapshot = await _firestore
          .collection(_collection)
          .doc(userId)
          .get()
          .timeout(_timeout);

      final data = snapshot.data();
      if (data == null) return null;

      return AddAddressDto.fromJson(data).toDomain();
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
      return null;
    }
  }
}

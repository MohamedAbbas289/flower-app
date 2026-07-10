import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/features/shopping/data/data_sources_contract/shopping_firestore_data_source_contract.dart';
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
}
